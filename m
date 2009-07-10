Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGJHfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGJHfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZGJHfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:35:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53520 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZGJHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:35:45 -0400
Date: Fri, 10 Jul 2009 09:35:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710073537.GA28106@elf.ucw.cz>
References: <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org> <20090707195129.GB24203@elf.ucw.cz> <19028.19921.30399.762710@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19028.19921.30399.762710@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 17:42:09, tridge@samba.org wrote:
> Hi Pavel,
> 
>  > It worked before. You claim that devices not understanding long
>  > filenames are now extinct, but that camera is the counterexample.
> 
> I certainly never claimed that devices that don't understand long
> filenames are extinct! I own more than one digital camera that doesn't
> understand long filenames.

Ok, so it really should not be called vfat, and really should not be
"default y".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
