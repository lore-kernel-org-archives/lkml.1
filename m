Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbZLKV7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbZLKV7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:59:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbZLKV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:58:58 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:34458 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812AbZLKV66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:58:58 -0500
Date: Fri, 11 Dec 2009 22:59:03 +0100
Message-Id: <486209117@web.de>
MIME-Version: 1.0
From: Peter Paul <abnominales@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18xnlS65fb75DU2FI3zVgDZBSRBdZrOzlZ2jadqyEUudoWZi
 P1liukbLmsakKgfLu5wA1N6D9wh2Xb9mFsQOnRkVIx6yjpkWdG7iTDc51rqk
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009 09:43:33 +0000 (GMT), Alex Buell wrote
> On Sun, 1 Feb 2009 12:46:00 +0000 (GMT), I waved a wand and this
> message magically appears in front of A B:
> > > I've updated the tarballs to fix the bug he found. If someone tried
> > > old tarballs, please download new tarballs and try.
> > > 
> > >     http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz
> 
> I have just converted your set of patches into a standalone module
> driver that you can build outside the kernel as long as you have a
> recent version of the kernel sources installed (currently 2.6.27). 
> 
> The only modification I needed to make was to add an extern for sys_tz
> in utils.c (extern struct timezone sys_tz)
> 
> The bz2 tarball can be found at:
> http://www.munted.org.uk/programming/exfat.tar.bz2

Is that one still alive? Maybe this should go into staging, now that exFAT got proposed as standard file system for SDXC [1] cards.

[1] http://www.sdcard.org/developers/tech/sdxc
______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

