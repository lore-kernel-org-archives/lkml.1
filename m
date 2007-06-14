Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXFNH32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXFNH32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXFNH3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:29:21 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51378 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbXFNH3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:29:20 -0400
Date: Thu, 14 Jun 2007 09:41:43 +0200
To: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/03] kbuild, asm-values: infrastructure
Message-ID: <20070614074143.GK7266@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612234558.648949000@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jun 13, 2007 at 01:36:51AM +0200, asm-values patch set:
> 	* header with widely used value definitions
> 	* handle all asm-related things in one file (Makefile.asm)
> 	* move some asm bits from Makefile.build there
> 	  (rule %.s:%.c)
> 	* add script to generate headers from assembles output
> 	  (hopefully better output, MIPS testing/joining to all arch
> 	   probably needed)
> 
> rfc-by: Oleg Verych
> ---

So, is it another not so juicy lets-break-it-all stuff from me, or it just
doesn't apply for you?

I thought update all that asm-offsets stuff just like that. I want to
know, why it does not fit.

Thanks.
____
