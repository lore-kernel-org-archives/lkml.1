Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYHOK00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYHOK00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHOK0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:26:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYHOK0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:26:18 -0400
Date: Fri, 15 Aug 2008 12:25:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86_64: uml: fix rename header guard
Message-ID: <20080815102553.GA16320@elte.hu>
References: <48A4CD01.9080805@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A4CD01.9080805@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> In unistd_64.h, the guard macro _ASM_X86_64_UNISTD_H_ is renamed to
> ASM_X86__UNISTD_64_H.
> 
> This change should be applied to arch/um/sys-x86_64/syscall_table.c.

applied to tip/x86/core - thanks!

	Ingo
