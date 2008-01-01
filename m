Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYAAQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYAAQPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYAAQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:15:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46209 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753604AbYAAQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:15:43 -0500
Date: Tue, 1 Jan 2008 16:07:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101160708.5bb5cc2a@the-village.bc.nu>
In-Reply-To: <20080101151751.GW2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist>
	<20080101142344.769f16c7@the-village.bc.nu>
	<20080101151751.GW2360@does.not.exist>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 17:17:51 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Tue, Jan 01, 2008 at 02:23:44PM +0000, Alan Cox wrote:
> > On Tue, 1 Jan 2008 15:48:09 +0200
> > Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > This patch removes the EXPERIMENTAL option and all dependencies on
> > > EXPERIMENTAL since they are pointless.
> > 
> > NAK
> > 
> > Experimental is an important guide to driver and code quality. 
> >...
> 
> History has shown that EXPERIMENTAL tags in many areas of the kernel 
> have not been maintained in a way that they would be usable as a guide.

Repeatedly posting crud does not make it right. As far as I can see the
tags are pretty honest for the most part - some have been experimental
for ten years but the 3c507 driver *has* always been a beta grade driver.

> And as soon as you need _one_ driver or feature depending on 
>> That's not about consensus,

It should be.

Alan
