Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYCYPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYCYPbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYCYPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:31:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYCYPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:31:07 -0400
Date: Tue, 25 Mar 2008 16:30:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 019/148] include/asm-x86/cpufeature.h: checkpatch
	cleanups - formatting only
Message-ID: <20080325153053.GB20898@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-20-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206259443-13210-20-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Joe Perches <joe@perches.com> wrote:

> +#define X86_FEATURE_REP_GOOD     _CF(3, 16) /* rep microcode works well
> +					     * on this CPU */

that is crap too ...

	Ingo
