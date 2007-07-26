Return-Path: <linux-kernel-owner+w=401wt.eu-S936273AbXGZSTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273AbXGZSTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934160AbXGZSTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:19:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934549AbXGZSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:19:06 -0400
Date: Thu, 26 Jul 2007 11:18:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Gabriel C <nix.or.die@googlemail.com>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707261405.09278.lenb@kernel.org>
Message-ID: <alpine.LFD.0.999.0707261116540.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707260026.08183.lenb@kernel.org>
 <46A8727F.3030005@googlemail.com> <200707261405.09278.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Len Brown wrote:
> 
> Can you be specific about how much additional "bloat" your system
> must endure with CONFIG_ACPI_SLEEP=y

All of CONFIG_HOTPLUG_CPU. 

Len, this is not about ACPI code. This is about CONFIG_HOTPLUG_CPU. Which 
I don't want. And which you forced on me.

		Linus
