Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZGHHmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZGHHmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbZGHHmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:42:31 -0400
Received: from mail.samba.org ([66.70.73.150]:39487 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbZGHHm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:42:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <19028.19274.528297.635416@samba.org>
Date: Wed, 8 Jul 2009 17:31:22 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907062237030.27775@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
	<19025.63119.656216.431469@samba.org>
	<alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr>
	<19026.24032.83454.892631@samba.org>
	<alpine.LSU.2.00.0907062237030.27775@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Without the two of your patches everything Works As Expected$,1ub(B.
 > 
 > (With yours, the file is displayed - as in "existence" -, with longname,
 > but does not play.)

As I mentioned elsewhere, I've now ordered some cheap MP3 players from
eBay to see if I can reproduce the problem. If you know of some place
online where I can also buy the same model you have in case the ones
I've ordered don't show problems, please let me know.

Cheers, Tridge
