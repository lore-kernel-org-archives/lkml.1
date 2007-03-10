Return-Path: <linux-kernel-owner+w=401wt.eu-S1767031AbXCJOEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767031AbXCJOEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 09:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767033AbXCJOEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 09:04:36 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:51577 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767031AbXCJOEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 09:04:35 -0500
Date: Sat, 10 Mar 2007 15:03:44 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Where is Linux 2.6.20.2?
In-Reply-To: <200703102152.GIF00641.VOFFSMJOFHLtOQ@I-love.SAKURA.ne.jp>
Message-ID: <Pine.LNX.4.61.0703101503220.8799@yvahk01.tjqt.qr>
References: <200703102133.IFJ33040.OFJtSFOVQOHMLF@I-love.SAKURA.ne.jp>
 <2375c9f90703100442o64d32d17k600ed7b8f2175cc8@mail.gmail.com>
 <200703102152.GIF00641.VOFFSMJOFHLtOQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 21:52, Tetsuo Handa wrote:

>Date: Sat, 10 Mar 2007 21:52:23 +0900
>From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>To: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org
>Subject: Re: Where is Linux 2.6.20.2?
>
>Cong WANG wrote:
>> http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.2.tar.bz2
>> isn't it what you want?
>It's currently 404 (Not Found) error.
>
>http://www2.kernel.org/ page is still showing 2.6.20.1
>although it once showed 2.6.20.2 .

15:02 ichi:/dev/shm > l /lnk/lk/linux-2.6.20.2.tar.
linux-2.6.20.2.tar.bz2       linux-2.6.20.2.tar.gz.sign
linux-2.6.20.2.tar.bz2.sign  linux-2.6.20.2.tar.sign
linux-2.6.20.2.tar.gz        
15:02 ichi:/dev/shm > l /lnk/lk/linux-2.6.20.2.tar.bz2
-rw-r--r-- 1 455 5200 43378711 Mar  9 20:08 /lnk/lk/linux-2.6.20.2.tar.bz2
15:02 ichi:/dev/shm > df -T `readlink -f /lnk/lk`
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
134.76.10.1:/ftp/pub
               nfs   5044816000 3911586640 1048766112  79% /F

It is synced out to the world already.


Jan
-- 
