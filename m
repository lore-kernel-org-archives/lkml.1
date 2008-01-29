Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbYA2Rtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbYA2Rtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYA2Rt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:49:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37120 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbYA2RtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:49:25 -0500
Date: Tue, 29 Jan 2008 17:44:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080129174455.62742b82@core>
In-Reply-To: <alpine.LNX.1.00.0801291220540.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com>
	<200801291132.41657.gene.heskett@gmail.com>
	<18335.22763.625990.528217@alkaid.it.uu.se>
	<200801291204.44671.gene.heskett@gmail.com>
	<alpine.LNX.1.00.0801291220540.13593@iabervon.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> things in the kernel that refer to SCSI probably should say "storage" (or 
> "ATA", really, but that would make the acronyms confusing).

SCSI is a command protocol. It is what your CD-ROM drive and USB storage
devices talk (albeit with a bit of an accent).

Alan
