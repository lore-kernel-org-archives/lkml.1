Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYJVQEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYJVQEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYJVQEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:04:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYJVQE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:04:29 -0400
Date: Wed, 22 Oct 2008 18:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH linux-tip] x86: Change OPTIMIZE_INLINING help to say
	enabling makes smaller kernels
Message-ID: <20081022160416.GO23060@elte.hu>
References: <20081011192753.GA13493@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011192753.GA13493@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0153]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> The OPTIMIZE_INLINING help currently says "The gcc 4.x series have a
> rewritten inlining algorithm and disabling this option will generate a
> smaller kernel there."
> 
> This contradicts other parts of the help text and my own tests:
> 5463127 2008-10-11 19:51 vmlinux.no-opt
> 5456152 2008-10-11 19:56 vmlinux.opt
> 
> Reword text to say that enabling OPTIMIZE_INLINING will lead to smaller
> kernels with gcc 4.x or later.
> 
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>

applied, thanks Sitsofe!

	Ingo
