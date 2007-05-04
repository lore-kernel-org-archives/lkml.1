Return-Path: <linux-kernel-owner+w=401wt.eu-S1161581AbXEDUME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161581AbXEDUME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161584AbXEDUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:12:03 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:13993 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161581AbXEDUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:12:00 -0400
Message-ID: <463B9380.5090503@interia.pl>
Date: Fri, 04 May 2007 22:11:44 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> <463B687D.1020600@interia.pl> <Pine.LNX.4.61.0705042042270.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705042042270.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: d3812acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Btw. I've been writting many times: if You want to use ondemand with 
>> Longhaul You don't need cpufreq at all.
> 
> Does VIA Nehemiah do hardware-driven autoregulation like Transmeta
> Crusoe too? (I suspect no, have not seen that happen.)
No.
>> It is just one another cool gadget for You.
>> Longhaul wasn't designed to change frequency often. 
> 
> Is there a way I can start with a specific governor (powersave) right
> from the start so that all devices that Linux will initialize assume
> the CPU runs at <choose something> MHz?
You have to search cpufreq mail list archives. I think that I saw 
patch recently.
>> It has big latency and requires so much preparation that it isn't worth 
>> if You don't need to save power or cool down CPU. 
> 
> I found frequency switching on my VIA to be fast enough.
Timer frequency equal to 1000Hz? 
> Jan
Rafa³



----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

