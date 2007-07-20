Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbXGTDr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbXGTDr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXGTDrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:47:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54232 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbXGTDrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:47:18 -0400
Date: Fri, 20 Jul 2007 06:00:50 +0200
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: asm-offsets
Message-ID: <20070720040050.GC475@flower.upol.cz>
References: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org> <E1IBdoz-0005Ol-6b@flower> <1184895253.10380.227.camel@localhost.localdomain> <20070720032236.GB475@flower.upol.cz> <1184901820.10380.254.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184901820.10380.254.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:23:40PM +1000, Rusty Russell wrote:
> 	I appreciate your frustration!

It isn't, just a conversation, everyone can skip, you know.

> Unfortunately I'm not fluent enough in kbuild to be able to give
> meaningful commentary,

Modest Rusty :)

> so pinging Sam is my way of helping this along...

Thanks for doing this, because apart from being more readable i've found
that for example dummy arch/sparc64/kernel/asm-offsets.c may benefit from
it as well.
____
