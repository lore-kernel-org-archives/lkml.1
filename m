Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYG1PMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYG1PMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYG1PMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:12:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYG1PMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:12:00 -0400
Date: Mon, 28 Jul 2008 17:11:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86-tip: adding extern to traps.h and syscalls.h
Message-ID: <20080728151145.GF32111@elte.hu>
References: <1216786365.2602.7.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216786365.2602.7.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> Can I add extern to all function declaration in asm-x86/trap.h and
> asm-x86/syscalls.h

yes, please do that.

	Ingo
