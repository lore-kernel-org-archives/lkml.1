Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZCKPc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZCKPc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZCKPcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:32:18 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:44805 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZCKPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:32:17 -0400
Message-ID: <49B7D979.7010406@turknet.net.tr>
Date: Wed, 11 Mar 2009 17:32:09 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ext4 problem on Linux-2.6.29-rc7-git4
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2009 15:32:10.0160 (UTC) FILETIME=[8B212300:01C9A25E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After booting into new 2.6.29-rc7-git4, I got a lot of errors below in 
dmesg. If it's a known issue or reported before, please ignore it.

Thanks,


[   87.972869] ext4: find_group_flex failed, fallback succeeded dir 
3199                                                     
[   87.996185] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.051789] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.166686] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.574640] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.575650] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.581875] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.592367] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   88.595424] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[   93.766084] __ratelimit: 3 callbacks 
suppressed                                                                            

[   93.766089] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  141.533514] ext4: find_group_flex failed, fallback succeeded dir 
91231                                                    
[  141.538206] ext4: find_group_flex failed, fallback succeeded dir 
44276                                                    
[  141.747876] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  144.267920] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  144.269304] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  144.270743] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  144.272727] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  144.757113] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  145.987488] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  149.776801] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  151.012097] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  151.012263] ext4: find_group_flex failed, fallback succeeded dir 
270                                                      
[  151.913137] ext4: find_group_flex failed, fallback succeeded dir 
270                                                      
[  152.619462] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  152.897305] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  152.930566] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  152.933778] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  152.950359] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  152.953722] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  170.656343] __ratelimit: 125 callbacks 
suppressed                                                                          

[  170.656347] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  170.658684] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  170.659887] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  171.944781] ext4: find_group_flex failed, fallback succeeded dir 
91233                                                    
[  173.975844] ext4: find_group_flex failed, fallback succeeded dir 
93760                                                    
[  173.984712] ext4: find_group_flex failed, fallback succeeded dir 
180006                                                   
[  173.994632] ext4: find_group_flex failed, fallback succeeded dir 
173294                                                   
[  174.002575] ext4: find_group_flex failed, fallback succeeded dir 
173294                                                   
[  174.013019] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  174.020086] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  179.709611] __ratelimit: 2 callbacks 
suppressed                                                                            

[  179.709616] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  179.712343] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  182.584232] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  182.584650] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  182.606425] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  182.619401] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  183.999261] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  184.473781] ext4: find_group_flex failed, fallback succeeded dir 
263                                                      
[  185.416915] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  185.675978] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  194.968331] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  195.086258] ext4: find_group_flex failed, fallback succeeded dir 
93727                                                    
[  195.086600] ext4: find_group_flex failed, fallback succeeded dir 
93564                                                    
[  196.198307] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  196.387716] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  196.622641] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  198.491449] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  201.911824] ext4: find_group_flex failed, fallback succeeded dir 
91233                                                    
[  204.714131] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.716209] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.717948] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.720704] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.804723] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.875122] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.941567] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.942883] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  204.943975] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  211.638861] __ratelimit: 73 callbacks 
suppressed                                                                           

[  211.638866] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  211.639938] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  213.439799] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  215.352344] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  215.352767] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  217.777083] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  217.784517] ext4: find_group_flex failed, fallback succeeded dir 
270                                                      
[  218.013981] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  218.214146] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  222.263144] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  222.310091] ext4: find_group_flex failed, fallback succeeded dir 
90979                                                    
[  222.316042] ext4: find_group_flex failed, fallback succeeded dir 
90979                                                    
[  222.499430] ext4: find_group_flex failed, fallback succeeded dir 
93727                                                    
[  222.499754] ext4: find_group_flex failed, fallback succeeded dir 
93564                                                    
[  223.396699] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  225.298729] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  229.123683] ext4: find_group_flex failed, fallback succeeded dir 
91013                                                    
[  231.912341] ext4: find_group_flex failed, fallback succeeded dir 
91233                                                    
[  233.666336] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  233.666571] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  233.666741] ext4: find_group_flex failed, fallback succeeded dir 
93759                                                    
[  244.698308] ext4: find_group_flex failed, fallback succeeded dir 
90997                                                    
[  245.091142] ext4: find_group_flex failed, fallback succeeded dir 263
[  250.216814] ext4: find_group_flex failed, fallback succeeded dir 93759
[  256.395520] ext4: find_group_flex failed, fallback succeeded dir 180006
[  257.711338] ext4: find_group_flex failed, fallback succeeded dir 44276
[  257.739477] ext4: find_group_flex failed, fallback succeeded dir 180006
[  257.741842] ext4: find_group_flex failed, fallback succeeded dir 208891
[  261.915214] ext4: find_group_flex failed, fallback succeeded dir 91233
[  262.436972] ext4: find_group_flex failed, fallback succeeded dir 180006
[  262.847569] ext4: find_group_flex failed, fallback succeeded dir 208920
[  262.847914] ext4: find_group_flex failed, fallback succeeded dir 208920
[  264.219725] ext4: find_group_flex failed, fallback succeeded dir 212335
[  264.220045] ext4: find_group_flex failed, fallback succeeded dir 212335


