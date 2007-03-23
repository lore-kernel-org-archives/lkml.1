Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXCWOPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXCWOPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXCWOPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:15:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53521 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXCWOPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:15:09 -0400
Date: Fri, 23 Mar 2007 15:15:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386 GDT cleanups: Rename boot_gdt_table to boot_gdt
Message-ID: <20070323141508.GC20548@one.firstfloor.org>
References: <1174458636.11680.143.camel@localhost.localdomain> <1174458730.11680.145.camel@localhost.localdomain> <1174458938.11680.150.camel@localhost.localdomain> <m1aby7c59k.fsf@ebiederm.dsl.xmission.com> <1174478153.11680.183.camel@localhost.localdomain> <m1wt1abkuo.fsf@ebiederm.dsl.xmission.com> <1174521510.2713.61.camel@localhost.localdomain> <20070322091031.33a753fe@frecb000686.frec.bull.fr> <1174555451.2713.139.camel@localhost.localdomain> <20070322165925.3630fce9@frecb000686.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322165925.3630fce9@frecb000686.frec.bull.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  Rename boot_gdt_table to boot_gdt to avoid the duplicate
> T(able).

We already have so much code churn in this area now, please
no pointless renames for at least two releases.

Thanks.

-Andi
