Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbXFGPjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbXFGPjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763188AbXFGPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:39:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33000 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758235AbXFGPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:39:27 -0400
Date: Thu, 7 Jun 2007 16:44:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Message-ID: <20070607164409.42635a4a@the-village.bc.nu>
In-Reply-To: <20070607152308.GB6653@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu>
	<20070607152308.GB6653@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:23:08 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> On Thu, Jun 07, 2007 at 04:22:51PM +0100, Alan Cox wrote:
> > The intel-rng printed a nice well formatted message when the port was
> > disabled. Someone then came along and blindly trashed it by screwing up a
> > trim down to 80 columns.
> > 
> > Put it back into the right format and keep the overlong lines as the
> > result is also MUCH easier to read in this specific case.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Acked-by: Jeff Garzik <jeff@garzik.org>
> 
> I'm not the driver maintainer anymore, so I'm not actually going to push
> this one.

Then please send a patch for the MAINTAINERS file

Alan
