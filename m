Return-Path: <linux-kernel-owner+w=401wt.eu-S966287AbXDGTni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287AbXDGTni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 15:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDGTni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 15:43:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:15598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966287AbXDGTnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 15:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=P4pq900fUbHiwChukjg/RPYUM1ReQDeTQti6UZxgIW0LRfC0as+mhsoRGFPnN3AJvm3+k+D17RgOTjjgcqFfn4vMesKcjJ88r9juMo44eKJ985fN7Xft+RrMXUGesjjZXcWqrAQF8g/KH2OX2bJpcY4L6MLk6uJm9Vj7WRsGICI=
Message-ID: <4617F455.2050401@googlemail.com>
Date: Sat, 07 Apr 2007 21:43:17 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
In-Reply-To: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
> 
> It contains the following patches against 2.6.21-rc6:

suspend-to-disk doesn't work when pktgen module is loaded.

Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
 kpktgend_0
 kpktgend_1
Restarting tasks ... done.
swsusp: Basic memory bitmaps freed

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-serialconsole2.log

Anyway, this kernel is pretty stable :)

aio_dio_bugs - ok
aiostress - ok
bash_shared_mapping - ok
bonnie - ok
cpu_hotplug - ok
cyclictest - ok
dbench - ok
fsfuzzer - ok
fs_mark - ok
fsx - ok
interbench - ok
iozone -ok
isic - ok
linus_stress - ok
ltp - ptrace bug
pi_tests - ok
rmaptest - ok
rtlinuxtests - ok
rttester - ok
scrashme - ok
spew - ok
stress - ok

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
