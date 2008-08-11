Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYHKQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYHKQvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYHKQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:50:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbYHKQu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:50:57 -0400
Date: Mon, 11 Aug 2008 18:50:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       x86@kernel.org
Subject: Re: [PATCH] EFI: fix function prototype
Message-ID: <20080811165008.GH4524@elte.hu>
References: <20080807151239.2fb2b75d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807151239.2fb2b75d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix function prototype in header file to match source code:
> 
> linux-next-20080807/arch/x86/kernel/efi_64.c:100:14: error: symbol 'efi_ioremap' redeclared with different type (originally declared at include2/asm/efi.h:89) - different address spaces

applied to tip/x86/urgent, thanks Randy.

	Ingo
