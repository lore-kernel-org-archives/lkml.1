Return-Path: <linux-kernel-owner+w=401wt.eu-S965893AbXCVJ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbXCVJ1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965895AbXCVJ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:27:52 -0400
Received: from ozlabs.org ([203.10.76.45]:60191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965893AbXCVJ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:27:51 -0400
Subject: Re: [PATCH 2/4] i386 GDT cleanups: Use per-cpu GDT immediately
	upon boot
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070322091031.33a753fe@frecb000686.frec.bull.fr>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <1174458636.11680.143.camel@localhost.localdomain>
	 <1174458730.11680.145.camel@localhost.localdomain>
	 <1174458938.11680.150.camel@localhost.localdomain>
	 <m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
	 <1174478153.11680.183.camel@localhost.localdomain>
	 <m1wt1abkuo.fsf@ebiederm.dsl.xmission.com>
	 <1174521510.2713.61.camel@localhost.localdomain>
	 <20070322091031.33a753fe@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 22 Mar 2007 20:24:10 +1100
Message-Id: <1174555451.2713.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 09:10 +0100, Sébastien Dugué wrote:
>   Why not take on the opportunity to rename boot_gt_table to boot_gtd,
> to avoid the duplicate T(able)?

That's not a bad idea, but IMHO deserves its own patch.

I look forward to it!
Rusty.


