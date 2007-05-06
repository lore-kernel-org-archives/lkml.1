Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXEFFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXEFFNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 01:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXEFFNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 01:13:23 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:24091 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754511AbXEFFNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 01:13:22 -0400
Message-ID: <463D63D8.8010901@interia.pl>
Date: Sun, 06 May 2007 07:12:56 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>  <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com> <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr> <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 327f6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> :-/ Weird. Nothing new in datasheet. Longhaul MSR seems to be OK too. 
>> Would be good to check if PLL really can go downto x4,0. Can You 
>> limit minimal CPU multiplier to 5,0 and check if is stable? If it 
>> is check 4,5.
> 
> I directly wrote to /sys/devices/system/cpu/cpu0/cpufreq, which
> worked better than `cpufreq -u xxx -d xxx`.
> 
> Lockup after 9 minutes. (Perhaps the longest time so far.)
Can You send me Your entire boot log with performance governor set? 
> Jan
Rafa³


----------------------------------------------------------------------
Po meczu.....kurde...:)
>>> http://link.interia.pl/f1a72

