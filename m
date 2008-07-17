Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYGQR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYGQR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbYGQR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:28:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39447 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbYGQR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:28:28 -0400
Date: Thu, 17 Jul 2008 19:28:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: fix asm/e820.h for userspace inclusion (again)
Message-ID: <20080717172814.GB28950@elte.hu>
References: <200807151502.27734.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151502.27734.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> asm-x86/e820.h is included from userspace.  'x86: make e820.c to have
> common functions' (b79cd8f1268bab57ff85b19d131f7f23deab2dee) broke it:

applied to tip/x86/urgent, thanks Rusty.

	Ingo
