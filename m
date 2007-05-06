Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXEFLgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXEFLgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXEFLgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:36:06 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42216 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645AbXEFLgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:36:05 -0400
Date: Sun, 6 May 2007 13:33:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463DAD29.20004@interia.pl>
Message-ID: <Pine.LNX.4.61.0705061330120.13826@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
 <463D63D8.8010901@interia.pl> <Pine.LNX.4.61.0705060959200.23047@yvahk01.tjqt.qr>
 <463D9E8E.8040500@interia.pl> <Pine.LNX.4.61.0705061125010.8623@yvahk01.tjqt.qr>
 <463DAD29.20004@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 6 2007 12:25, Rafał Bilski wrote:

>> Nevermind, it does not look like it gets any cooler at lower frequencies,
>> so it's a nobrainer to run it at the default 733.
>
>Well. You have very good CPU - 4,4W typical and 6,0W is a factory maximum.

Says who? TM5800 draws around 2.0W (or even less) when idle [333 MHz]. :)
Though it has a different hardware engine than most x86.

>My is eating 6,78W while *sleeping* at 1GHz or about 5W while *sleeping* at 
>533MHz.
>> Jan
>Rafał
>
>
>
>----------------------------------------------------------------------
>Wicie, rozumicie....
>Zobacz >>> http://link.interia.pl/f1a74
>

Jan
-- 
