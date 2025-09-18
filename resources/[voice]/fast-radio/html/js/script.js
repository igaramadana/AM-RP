$(document).ready(function() {
    let FastConfig = {}
    let TotalUser = 0
    let FavChannels = []
    let curChannel = 0
    let FastRadioData = {}


    $.post('https://fast-radio/getConfig', JSON.stringify({}), function(config) {
        FastConfig = config;
    
        $('#profile-header-1').text(FastConfig.Locales.yourProfile || 'YOUR');
        $('#profile-header-2').text(FastConfig.Locales.profile || 'PROFILE');
        $('#radio_maintab_button-text').text(FastConfig.Locales.main || 'MAIN');
        $('#radio_channelstab_button-text').text(FastConfig.Locales.channels || 'CHANNELS');
        $('#enter-header').text(FastConfig.Locales.enter || 'ENTER');
        $('#frequency-header').text(FastConfig.Locales.frequency || 'FREQUENCY');
        $('#connect-text').text(FastConfig.Locales.connect || 'CONNECT');
        $('#radio-header').text(FastConfig.Locales.radio || 'RADIO');
        $('#settings-header').text(FastConfig.Locales.settings || 'SETTINGS');
        $('#radio-size-text').text(FastConfig.Locales.radioSize || 'Radio Size');
        $('#memberlist-text').text(FastConfig.Locales.memberList || 'Member List');
        $('#move-radio-text').text(FastConfig.Locales.moveRadio || 'Move Radio');
        $('#radio-color-text').text(FastConfig.Locales.radioColor || 'Radio Color');
        $('#favorite-header').text(FastConfig.Locales.favorite || 'FAVORITE');
        $('#list-header').text(FastConfig.Locales.list || 'LIST');
        $('#radio_memberlist_header-1').text(FastConfig.Locales.activeMemberListFirstText || 'RADIO'); // Active Member List kısmı
        $('#radio_memberlist_header-2').text(FastConfig.Locales.activeMemberList || 'MEMBER LIST'); // Active Member List kısmı
    });
    
    
    function uiSounds()  {
        var vMusic = new Audio('sound/ui_click.mp3')
        vMusic.play()
    }



    window.addEventListener('message', function(event) {
        if (event.data.openUI === true) {
            document.getElementById("radio").style.display = "block";
            document.getElementById("firstname").innerHTML = event.data.playerFirstname;
            document.getElementById("lastname").innerHTML = event.data.playerLastname;
            document.getElementById("server_time").innerHTML = event.data.serverTime;
            document.getElementById("server_time-2").innerHTML = event.data.serverTime;
            document.getElementById("date").innerHTML = event.data.serverDate;
            
            const profilePicUrl = event.data.profilePhoto || 'default-profile.png';  
            if (profilePicUrl) {
                document.querySelector('.radio_userprofile_photo').style.backgroundImage = `url(${profilePicUrl})`;
            } else {
               
            }
    
            const remove = (sel) => document.querySelectorAll(sel).forEach(el => el.remove());
            remove(".radio_fav_channel-1");
            remove(".radio-fav-channel-num");
            remove(".radio-fav-hztext");
            remove(".radio-fav-star-x"); 
            remove(".radio-fav-connection-status"); 
            FavChannels = event.data.favChannels;
  
            loadFav(event.data.favChannels);
    
        } else if(event.data.closeUI === true) {
            document.getElementById("radio").style.display = "none";
    
        } else if (event.data.sendData == true ) {
            FastRadioData = JSON.parse(event.data.radioData);
            CurrentChannel = '"' + event.data.current_Channel + '"';
            updateMemberList();
            TotalUser = event.data.radioMemberCount
           
    
        } else if (event.data.updateData == true ) {
            const remove = (sel) => document.querySelectorAll(sel).forEach(el => el.remove());
            remove(".radio_fav_channel-1");
            remove(".radio-fav-channel-num");
            remove(".radio-fav-hztext");
            remove(".radio-fav-star-x"); 
            remove(".radio-fav-connection-status"); 
            loadFav(event.data.favChannels);
        } else if(event.data.disconnectRadio) {
            curChannel = 0
            updateConnectButton(false);
            document.querySelector('.radio_enterfreq_con').value = '';
            DisconnectRadio();
        }
    });
    
    function DisconnectRadio() {
        // console.log("allah")
        isConnected = false
        TotalUser = 0
        document.getElementById('radio_enterfreq_con').disabled = false;
        document.getElementById("radio_enterfreq_icon").style.backgroundImage = "url(img/bosstar.png)"
        document.getElementById("radio_memberlist_membercount").innerHTML = 0;
        const memberListBox = document.getElementById('radio_memberlist_container');
        const lines = document.getElementById('radio_memberlist-liness');
        memberListBox.innerHTML = ''; 
        lines.style.height = "7.604166666666666vw"
        memberListBox.style.height = "7.604166666666666vw" 
    }

    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            CloseUI();
        }
    });

    let isConnected = false 

    document.querySelector('.radio_enterfreq_favbutton').addEventListener('click', function() {
        let frequency = document.querySelector('.radio_enterfreq_con').value;
        uiSounds()
        if (frequency) {
        } else {
            console.log("error")
        }
    });

    curChannel = 0



    function updateConnectButton(connected) {
        const button = document.querySelector('.radio_enterfreq_connect-btn');
        
        if (connected) {
            // Show the member list when connected if AutoOpenMemberList is true
            if (FastConfig.AutoOpenMemberList) {
                document.getElementById("memberlist").style.display = "block";
                document.getElementById("radio_memberlist_membercount").innerHTML = TotalUser;
            }
            
            document.getElementById("radio_enterfreq_connect-btn").style.backgroundImage = "url(img/karam2.png)";
            button.querySelector('.radio_enterfreq_connect-btn-text').innerHTML = "Disconnect";
            isConnected = true;
        } else {
            // Hide the member list when disconnected
            document.getElementById("memberlist").style.display = "none";
            document.getElementById("radio_memberlist_membercount").innerHTML = 0;
    
            document.getElementById("radio_enterfreq_connect-btn").style.backgroundImage = "url(img/karam.png)";
            button.querySelector('.radio_enterfreq_connect-btn-text').innerHTML = "Connect";
            button.classList.remove("red"); 
            isConnected = false;
        }
    }
    

 
    
    document.querySelector('.radio_enterfreq_connect-btn').addEventListener('click', function() {
        let frequency = document.querySelector('.radio_enterfreq_con').value;
        
        uiSounds()
        if (!isConnected && frequency) {
            $.post('https://fast-radio/setFrequency', JSON.stringify({
                frequency: frequency
            }), function(response) {
                if (response.success) {
                    // CurrentFreq = frequency
                    document.getElementById('radio_enterfreq_con').disabled = true;
                    for (let i = 0; i < FavChannels.length; i++) {
                        if (FavChannels[i] == frequency) {
                            // console.log('allah');
                            document.getElementById("radio_enterfreq_icon").style.backgroundImage = "url(img/dolustar.png)"
                            break;
                        }
                    }

                    curChannel = frequency
                    // GetFavList()
                    updateConnectButton(true);
                }
            });

        } else if (isConnected) {
            $.post('https://fast-radio/disconnectRadio', function(response) {
                if (response.success) {
                    curChannel = 0
                    // GetFavList()
                    updateConnectButton(false);
                    document.querySelector('.radio_enterfreq_con').value = '';
                    DisconnectRadio();
                    
                }
            });
        }
    });


    document.getElementById('increase-volume-btn').addEventListener('click', function() {
        uiSounds()
        $.post('https://fast-radio/volume', JSON.stringify({ value: true }), function(response) {
            if (response.success) {
            }
        });
    });

    document.getElementById('decrease-volume-btn').addEventListener('click', function() {
        uiSounds()
        $.post('https://fast-radio/volume', JSON.stringify({ value: false }), function(response) {
            if (response.success) {
            }
        });
    });
    
    let toggleUI = false 

    document.getElementById("radio_settings-size-slider").addEventListener("input", function() {
        let value = Math.trunc(this.value);
        let scaleValue = 1.0 + (value * 0.002); 
        document.getElementById("radio").style.transform = `scale(${scaleValue})`;
    });

    let editMode = false; 
    dragElement(document.getElementById("radio-main-con"));
    dragElement(document.getElementById("memberlist"));

    let btnState = false 
    document.getElementById("fs").addEventListener("input", function() {
        uiSounds()
        if (btnState == false) {
            document.getElementById("memberlist").style.display = "block"
            document.getElementById("radio_memberlist_membercount").innerHTML = "0"
            // document.getElementById("radio-memberlist-box").display = "none"
            document.getElementById("radio_settings_memberlist_flipswitch-label").style.border = "0vw solid #92FF77";
            document.getElementById("radio_settings_memberlist_flipswitch-switch").style.background = "#92FF77";
            document.getElementById("radio_settings_memberlist_flipswitch-switch").style.border = "0vw solid #92FF77";
            btnState = true 
        } else {
            btnState = false
            document.getElementById("memberlist").style.display = "none"
            document.getElementById("radio_settings_memberlist_flipswitch-label").style.border = "0vw solid #ff7777";
            document.getElementById("radio_settings_memberlist_flipswitch-switch").style.background = "#ff7777";
            document.getElementById("radio_settings_memberlist_flipswitch-switch").style.border = "0vw solid #ff7777";  
        }
        // console.log(editMode);
    });
    
    document.getElementById("fss").addEventListener("input", function() {
        editMode = !editMode;
        uiSounds()
        dragElement(document.getElementById("radio-main-con"));
        dragElement(document.getElementById("memberlist"));
        // console.log(editMode);
    });

    function dragElement(elmnt) {
        if (editMode) {
            // uiSounds()
            document.getElementById("radio").style.cursor = "move";
            document.getElementById("memberlist").style.cursor = "move"
            document.getElementById("radio_settings_move_radio_flipswitch-label").style.border = "0vw solid #92FF77";
            document.getElementById("radio_settings_move_radio_flipswitch-switch").style.background = "#92FF77";
            document.getElementById("radio_settings_move_radio_flipswitch-switch").style.border = "0vw solid #92FF77";


            let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

            elmnt.onmousedown = dragMouseDown;

            function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                document.onmousemove = elementDrag;
            }

            function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                const newPosX = e.clientX;
                const newPosY = e.clientY;
                pos1 = pos3 - newPosX;
                pos2 = pos4 - newPosY;
                pos3 = newPosX;
                pos4 = newPosY;

                const newLeft = (elmnt.offsetLeft - pos1) / window.innerWidth * 100;
                const newTop = (elmnt.offsetTop - pos2) / window.innerHeight * 100;

                elmnt.style.left = newLeft + "vw";
                elmnt.style.top = newTop + "vh";
            }

            function closeDragElement() {
                document.onmouseup = null;
                document.onmousemove = null;
            }
        } else {
            document.getElementById("memberlist").style.cursor = "default"
            document.getElementById("radio_settings_move_radio_flipswitch-label").style.border = "0vw solid #ff7777";
            document.getElementById("radio_settings_move_radio_flipswitch-switch").style.background = "#ff7777";
            document.getElementById("radio_settings_move_radio_flipswitch-switch").style.border = "0vw solid #ff7777";
            document.getElementById("radio").style.cursor = "default";
            elmnt.onmousedown = null;
        }
    }

    function CloseUI() {
        document.getElementById("radio").style.display = "none";
        
        $.post("https://fast-radio/closeUI");
    }

    document.getElementById("black").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/radio_bg.png)"
    };

    document.getElementById("orange").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/custom/orange.png)"
    };

    document.getElementById("lime").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/custom/lime.png)"
    };

    document.getElementById("cyan").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/custom/cyan.png)"
    };

    document.getElementById("blue").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/custom/blue.png)"
    };

    document.getElementById("purple").onclick = function() {
        uiSounds()
        document.getElementById("radio").style.backgroundImage = "url(img/custom/purple.png)"
    };

 
    const saved_data = null 

   
    function updateMemberList() {
        
        const memberListBox = document.getElementById('radio_memberlist_container');
        const container = document.getElementById('radio_memberlist_container');
    

    
        // const Data = FastRadioData;
        // const users = Data;
        
        if (isConnected == true) {
            memberListBox.innerHTML = '';
            // document.getElementById("radio-memberlist-box").display = "block"
            memberListBox.style.height = `${TotalUser * 32}px`;
            document.getElementById("radio_memberlist_membercount").innerHTML = TotalUser;
            document.getElementById('radio_memberlist_container').style.height = `${TotalUser * 32}px`;
            document.getElementById('radio_memberlist-liness').style.height = `${TotalUser * 32}px`;
            FastRadioData.forEach(user => {
                if (user) {
                    const memberBox = document.createElement('div');
                    memberBox.className = 'radio_memberlist_member-box';
        
                    const memberIcon = document.createElement('div');
                    memberIcon.className = 'radio_memberlist_member-box-icon';
                    memberBox.appendChild(memberIcon);
        
                    const memberName = document.createElement('div');
                    memberName.className = 'radio_memberlist_member-box-name';
                    memberName.textContent = user.PlayerName;
                    memberBox.appendChild(memberName);
        
                    const micStatus = document.createElement('div');
                    micStatus.className = 'radio_memberlist_member-box-mic';
        
             
                    if (user.IsTalking == true) {
                        
                        micStatus.style.backgroundImage = "url('img/mic_active.png')";
                        memberBox.style.background = "linear-gradient(90deg, rgba(0, 255, 102, 0.00) 0%, rgba(0, 255, 102, 0.10) 100%), linear-gradient(90deg, rgba(33, 33, 33, 0.60) 0%, rgba(33, 33, 33, 0.00) 100%)";
                        // setTimeout(750)
                    } else {
                        
                        micStatus.style.backgroundImage = "url('img/mic.png')";
                        memberBox.style.background = "linear-gradient(90deg, rgba(33, 33, 33, 0.60) 0%, rgba(33, 33, 33, 0.00) 100%)";
                        // setTimeout(750)
                    }
        
                    memberBox.appendChild(micStatus);
                    memberListBox.appendChild(memberBox);
                    // setTimeout(750)
                }
            });
        } else {
            DisconnectRadio()
        }
        
    }
    
    
   


    const activeColor = "#548a47";
    const inactiveColor = "#ffffff1c";

    $("#radio_settings-size-slider").on("input", function() {
        const ratio = (this.value - this.min) / (this.max - this.min) * 100;
        $(this).css("background", `linear-gradient(90deg, ${activeColor} ${ratio}%, ${inactiveColor} ${ratio}%)`);
    });

    document.getElementById("radio_channelstab_button").onclick = function() {
        uiSounds()
        GetFavList()
        document.getElementById("radio_channelstab_button").style.backgroundImage = "url(img/l_greenhover.png)";
        document.getElementById("radio_channelstab_button-text").style.color = "#92FF77";
        document.getElementById("radio_maintab_button").style.backgroundImage = "url(img/l_grayhover.png)";
        document.getElementById("radio_maintab_button-text").style.color = "rgba(255, 255, 255, 0.38)";
        document.getElementById("radio_enterfrequency").style.display = "none";
        document.getElementById("radio_settings").style.display = "none";
        document.getElementById("radio_fav_channels").style.display = "block";
    };

    document.getElementById("radio_maintab_button").onclick = function() {
        uiSounds()
       
   
        document.getElementById("radio_maintab_button").style.backgroundImage = "url(img/radio_main_button.png)";
        document.getElementById("radio_maintab_button-text").style.color = "#92FF77";
        document.getElementById("radio_channelstab_button").style.backgroundImage = "url(img/radio_channels_button.png)";
        document.getElementById("radio_channelstab_button-text").style.color = "rgba(255, 255, 255, 0.38)";
        document.getElementById("radio_enterfrequency").style.display = "block";
        document.getElementById("radio_settings").style.display = "block";
        document.getElementById("radio_fav_channels").style.display = "none";
    };
    

    
    function loadFav(data) {
        const container = document.getElementById('favChannelsList');
    
        data.forEach((frequency, index) => {
            const channelDiv = document.createElement('div');
            channelDiv.classList.add('radio_fav_channel-1');
    
            const numDiv = document.createElement('div');
            numDiv.classList.add('radio-fav-channel-num');
            numDiv.textContent = frequency;
            channelDiv.appendChild(numDiv);
    
            const hzDiv = document.createElement('div');
            hzDiv.classList.add('radio-fav-hztext');
            hzDiv.textContent = 'Hz';
            channelDiv.appendChild(hzDiv);
    
            const starDiv = document.createElement('div');
            starDiv.classList.add('radio-fav-star-x');
            starDiv.style.backgroundImage = 'url("img/starbox.png")'; 
            channelDiv.appendChild(starDiv);
    
            const statusDiv = document.createElement('div');
            statusDiv.classList.add('radio-fav-connection-status');
            statusDiv.setAttribute('data-frequency', frequency); 
            updateStatusIcon(statusDiv, frequency);
            channelDiv.appendChild(statusDiv);
    
            statusDiv.addEventListener('click', () => {
                QuickConnectChannel(frequency, statusDiv);
            });
    
            starDiv.addEventListener('click', () => {
                uiSounds();
                $.post('https://fast-radio/removeFavoriteChannel', JSON.stringify({ frequency: data[index] }), function(response) {
                    if (response == true) {
                        // console.log("ok")
                        document.getElementById("radio_enterfreq_icon").style.backgroundImage = "url(img/star.png)"
                        container.removeChild(channelDiv);
                    }
                });
            });
    
            container.appendChild(channelDiv);
        });
    }
    
    function updateStatusIcon(statusDiv, frequency) {
        if (curChannel == 0) {
            statusDiv.style.backgroundImage = 'url("img/disconnect.png")'; 
        } else if (curChannel == frequency) {
            statusDiv.style.backgroundImage = 'url("img/connected.png")'; 
        } else {
            statusDiv.style.backgroundImage = 'url("img/disconnect.png")'; 
        }
    }
    
    function QuickConnectChannel(freq, statusDiv) {
        uiSounds();
        const previousChannel = curChannel; 
    
        if (freq === curChannel) {
            $.post('https://fast-radio/disconnectRadio', function(response) {
                if (response.success) {
                    curChannel = 0;
                    updateConnectButton(false);
                    DisconnectRadio();
                    document.querySelector('.radio_enterfreq_con').value = '';
                    statusDiv.style.backgroundImage = 'url("img/disconnect.png")'; 
                }
            });
        } else {
            if (!isConnected) {
                $.post('https://fast-radio/setFrequency', JSON.stringify({ frequency: freq }), function(response) {
                    if (response.success) {
                        DisconnectRadio();
                
                        document.querySelector('.radio_enterfreq_con').value = freq;
                        document.getElementById('radio_enterfreq_con').disabled = true;
                        const previousStatusDiv = document.querySelector(`.radio-fav-connection-status[data-frequency="${previousChannel}"]`);
                        if (previousStatusDiv) {
                            previousStatusDiv.style.backgroundImage = 'url("img/disconnect.png")'; 
                        }
                        for (let i = 0; i < FavChannels.length; i++) {
                            if (FavChannels[i] == freq) {
                                // console.log('allah');
                                document.getElementById("radio_enterfreq_icon").style.backgroundImage = "url(img/dolustar.png)"
                                break;
                            }
                        }
                        curChannel = freq;
                        updateConnectButton(true);
                        updateStatusIcon(statusDiv, freq);
                        statusDiv.style.backgroundImage = 'url("img/connected.png")'; 
                    }
                });
            } else {
                $.post('https://fast-radio/error2', JSON.stringify({ frequency: freq }), function() {
                });
            }
           
        }
    }
    
    function GetFavList(){
        const remove = (sel) => document.querySelectorAll(sel).forEach(el => el.remove());
        remove(".radio_fav_channel-1");
        remove(".radio-fav-channel-num");
        remove(".radio-fav-hztext");
        remove(".radio-fav-star-x"); 
        remove(".radio-fav-connection-status"); 
        $.post("https://fast-radio/LoadFavorite");
    }

    document.querySelector('.radio_enterfreq_favbutton').addEventListener('click', function() {
        let frequency = document.querySelector('.radio_enterfreq_con').value;
        
        if (frequency && isConnected) {
            $.post('https://fast-radio/addFavoriteChannel', JSON.stringify({ frequency: frequency }), function() {
            });
            document.getElementById("radio_enterfreq_icon").style.backgroundImage = "url(img/dolustar.png)"
        } else {
            $.post('https://fast-radio/error', JSON.stringify({ frequency: frequency }), function() {
            });
        }
    });




   
});




