Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYHSBp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYHSBp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYHSBpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:45:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYHSBpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:45:12 -0400
Date: Tue, 19 Aug 2008 03:44:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: robert.richter@amd.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>
Subject: Re: [PATCH] x86: Coding style fixes to
	arch/x86/oprofile/op_model_p4.c
Message-ID: <20080819014458.GG14821@elte.hu>
References: <20080818212538.4129d0ac@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818212538.4129d0ac@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Ingo, Robert,
> 
> From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> 
> A coding style patch to arch/x86/oprofile/op_model_p4.c that
> removes 87 errors and 4 warnings.
> 
> Before:
> total: 89 errors, 13 warnings, 722 lines checked
> 
> After:
> total: 2 errors, 9 warnings, 721 lines checked

nice! Applied to tip/x86/oprofile and also merged into tip/oprofile, 
thanks Paolo.

	Ingo
