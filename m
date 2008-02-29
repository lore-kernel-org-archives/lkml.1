Return-Path: <linux-kernel-owner+w=401wt.eu-S933512AbYB2RQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbYB2RQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbYB2RPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:15:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757829AbYB2RPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:15:47 -0500
Date: Fri, 29 Feb 2008 17:04:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
Message-ID: <20080229170446.48aff87d@core>
In-Reply-To: <200802291804.09412.bzolnier@gmail.com>
References: <47C75392.3020606@garzik.org>
	<47C7FA8B.7040306@gmail.com>
	<20080229140106.41ccc843@core>
	<200802291804.09412.bzolnier@gmail.com>
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

> > legacy old IDE driver might but that probably isn't going to be fixed by
> > devres and is trivial to fix in that driver (just steal the code from
> > pata_legacy).
> 
> Yep, nice trick.
> 
> Since it is your idea/code could you please also fix ide_generic? :)

In my copious free time - ask me around August ;)

Alan
