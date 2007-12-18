Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXLROC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXLROC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXLROCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:02:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbXLROCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:02:51 -0500
Date: Tue, 18 Dec 2007 15:02:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] x86: unify module_{32|64}.h
Message-ID: <20071218140240.GE17470@elte.hu>
References: <1197979829.7734.36.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197979829.7734.36.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> >From 5be3fc6a0e28d82a05487a8fb1a86532fb0ad4e8 Mon Sep 17 00:00:00 2001
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Tue, 18 Dec 2007 03:58:10 -0800
> Subject: [PATCH] x86: unify module_{32|64}.h
> 
> This adds one case to the MODULE_PROC_FAMILY block testing
> for X86_64.  There are no new things defined on X86_64 than
> there were before.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, let a single checkpatch warning go by in the first one,
> fixed in this version.

thanks, applied.

	Ingo
