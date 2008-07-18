Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYGRQwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYGRQwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYGRQwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:52:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbYGRQwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:52:33 -0400
Date: Fri, 18 Jul 2008 18:52:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: Introducing asm-x86/traps.h
Message-ID: <20080718165216.GF6875@elte.hu>
References: <1216136353.2747.3.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216136353.2747.3.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Declaring x86 traps under one hood.
> Declaring x86 do_traps before defining them.

applied to tip/x86/core, thanks!

	Ingo
