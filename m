Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbXH3Sc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbXH3Sc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbXH3Sci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:32:38 -0400
Received: from corky.net ([212.150.53.130]:38817 "EHLO zebday.corky.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761010AbXH3ScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:32:23 -0400
Message-ID: <46D70BE7.2020503@corky.net>
Date: Thu, 30 Aug 2007 19:26:47 +0100
From: Just Marc <marc@corky.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
References: <46CFEB36.9020806@corky.net> <Pine.LNX.4.64.0708302024320.24730@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708302024320.24730@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP on CorKy.NeT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One must consult the documentation of that device.   This wear leveling 
is low level and most devices do not export any information about it.  
Recent SSDs start to export some values through SMART that let you 
monitor the state.

Some companies think that hiding is better than exposing...


Jan Engelhardt wrote:
> On Aug 25 2007 09:41, Just Marc wrote:
>   
>> On SSDs which contain built in wear leveling, pretty much any file 
>> system can be used.  For SSDs that lack such low level housekeeping, 
>> use stuff like JFFS2.
>>     
>
> The question is, how can you find out whether it does automatic 
> wear-leveling? (Perhaps when a CF is advertised as "holds 10 years!"?)
>
>
> 	Jan
>   

