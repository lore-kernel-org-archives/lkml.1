Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbXCWHUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbXCWHUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934026AbXCWHT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:19:59 -0400
Received: from ozlabs.org ([203.10.76.45]:43434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904AbXCWHT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:19:58 -0400
Subject: Re: [PATCH] i386 GDT cleanups: Rename boot_gdt_table to boot_gdt
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070322165925.3630fce9@frecb000686.frec.bull.fr>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <1174458636.11680.143.camel@localhost.localdomain>
	 <1174458730.11680.145.camel@localhost.localdomain>
	 <1174458938.11680.150.camel@localhost.localdomain>
	 <m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
	 <1174478153.11680.183.camel@localhost.localdomain>
	 <m1wt1abkuo.fsf@ebiederm.dsl.xmission.com>
	 <1174521510.2713.61.camel@localhost.localdomain>
	 <20070322091031.33a753fe@frecb000686.frec.bull.fr>
	 <1174555451.2713.139.camel@localhost.localdomain>
	 <20070322165925.3630fce9@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 23 Mar 2007 18:19:40 +1100
Message-Id: <1174634380.29496.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 16:59 +0100, Sébastien Dugué wrote:
>  Rename boot_gdt_table to boot_gdt to avoid the duplicate
> T(able).
> 
> Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
> 
> ---
>  arch/i386/kernel/head.S       |    9 ++++-----
>  arch/i386/kernel/trampoline.S |   12 ++++++------
>  2 files changed, 10 insertions(+), 11 deletions(-)

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

In future, I'd recommend adding a witty comment to any such trivial
patch: it's really the only way to get it featured on LWN's Kernel Quote
of the Week.

Damn you Jon for turning us all into show ponies! (*Hi mum!*)
Rusty.

