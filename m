Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXEFK0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXEFK0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbXEFK0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:26:00 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:10174 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933591AbXEFKZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:25:59 -0400
Message-ID: <463DAD29.20004@interia.pl>
Date: Sun, 06 May 2007 12:25:45 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>  <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com> <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr> <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr> <463D63D8.8010901@interia.pl> <Pine.LNX.4.61.0705060959200.23047@yvahk01.tjqt.qr> <463D9E8E.8040500@interia.pl> <Pine.LNX.4.61.0705061125010.8623@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705061125010.8623@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: fcd4acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Nevermind, it does not look like it gets any cooler at lower frequencies,
> so it's a nobrainer to run it at the default 733.
Well. You have very good CPU - 4,4W typical and 6,0W is a factory maximum.
My is eating 6,78W while *sleeping* at 1GHz or about 5W while *sleeping* at 
533MHz.
> Jan
Rafa³



----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

