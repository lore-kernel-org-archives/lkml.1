Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXFWTSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXFWTSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXFWTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:17:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33599 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752296AbXFWTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:17:56 -0400
Date: Sat, 23 Jun 2007 20:23:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grozdan Nikolov <microchip@chello.be>
Cc: Torsten Duwe <duwe@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: How innovative is Linux?
Message-ID: <20070623202343.621a244b@the-village.bc.nu>
In-Reply-To: <200706231819.43556.microchip@chello.be>
References: <200706231417.16086.microchip@chello.be>
	<20070623164608.05dc5c30@the-village.bc.nu>
	<200706231812.02317.duwe@lst.de>
	<200706231819.43556.microchip@chello.be>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 18:19:43 +0200
Grozdan Nikolov <microchip@chello.be> wrote:

> On Saturday 23 June 2007 18:12, you wrote:
> > On Saturday 23 June 2007, Alan Cox wrote:
> > > A few innovations that afaik first appeared the Linux kernel
> > > - Making multiple hosts appear transparently as one IP address
> > > - Futex fast hybrid locking
> > > - Single pass checksum fragment and send fragments in reverse order
> > > - Reiserfs - very innovative design, but innovation isn't neccessarily
> > > success
> > > - JFFS/JFFS2 - flash wear levelled file system avoiding all the problem
> > > patents
> > > - Loadable modules for a non-microkernel
> >
> > - ALSA framework and drivers
> > - Direct Rendering Infrastructure

DRI is based on SGI work and Mark Kilgard and the SGI folks definitely
did the real visionary work in that area.

> > - hotplugging
> >
> 
> hmm, wasn't loadable kernel modules first implemented in SunOS 4.x together 
> with the proc system ?

Proc type stuff is a lot older than Linux or Unix AFAIK. Loadable modules
ditto but the full load/unload/autoload stuff I've not seen pre-Linux.
