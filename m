Return-Path: <linux-kernel-owner+w=401wt.eu-S937827AbXFGWcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937827AbXFGWcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937718AbXFGWcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:32:19 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50190 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937711AbXFGWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:32:18 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Date: Thu, 7 Jun 2007 18:32:13 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
References: <20070607162251.5f291325@the-village.bc.nu> <m3wsyfzcpt.fsf@maximus.localdomain>
In-Reply-To: <m3wsyfzcpt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071832.13486.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 17:17:18 Krzysztof Halasa wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > The intel-rng printed a nice well formatted message when the port was
> > disabled. Someone then came along and blindly trashed it by screwing up a
> > trim down to 80 columns.
>
> Perhaps we should drop that 80-column style and use some 120+?
> X or no X, almost all people now have more lines and columns on their
> displays than MDA 20 years ago.
>
> 132 to match text VGA perhaps?
> 80 can be left for the actual _output_, I mean number of chars printed
> by kernel code.

Why? My consoles are *all* still 80x24 text mode. It's only if I decide to 
monkey with the settings (and why fix what isn't broken?) or when I'm in X 
that I get a bigger screen than that.

I think the general consensus on the 80 character lines isn't for the average 
home user, but for the people that have things like old Wyse terminals and 
such hooked up.

DRH

