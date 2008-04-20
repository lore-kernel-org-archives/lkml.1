Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYDTMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYDTMGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYDTMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:06:07 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:54995 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbYDTMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:06:06 -0400
Date: Sun, 20 Apr 2008 12:37:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420123731.7282bb16@the-village.bc.nu>
In-Reply-To: <20080420115455.GJ1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
	<20080420080901.GF1595@cs181133002.pp.htv.fi>
	<20080420090623.7b173ef1@the-village.bc.nu>
	<20080420085104.GG1595@cs181133002.pp.htv.fi>
	<20080420103611.2c0d3519@the-village.bc.nu>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<20080420120250.4f496861@the-village.bc.nu>
	<20080420115455.GJ1595@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 14:54:55 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> Red Hat seems to get usable kernels with 4k for some years?

Yes and I think it is the right setting.

> If we get whatever is still missing for 4k working once and then the 
> coverage of all i386 -rc testers for noticing new issues immediately
> there should be no stability reason for distros to patch it back in.

You don't get to dictate to people however. 

Alan
--
  "If we become a great evil avaricious hegemony, I wanna cool uniform"
                        -- robk
