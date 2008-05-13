Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYEMNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYEMNGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYEMNGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:06:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbYEMNGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:06:00 -0400
Date: Tue, 13 May 2008 15:05:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make e820.c to have common functions
Message-ID: <20080513130539.GL14973@elte.hu>
References: <200805110030.15510.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805110030.15510.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0522]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> remove the duplicated copy of these functions.

applied, thanks. What a low-key commit message for the first step such a 
much-needed unification! :-)

any thoughts (or patches) about how to attack the rest of e820_32/64.c?

	Ingo
