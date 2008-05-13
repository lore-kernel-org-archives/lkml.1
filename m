Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYEMM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYEMM6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYEMM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:58:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbYEMM6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:58:09 -0400
Date: Tue, 13 May 2008 14:57:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to
	discrete layout - fix #2
Message-ID: <20080513125752.GI14973@elte.hu>
References: <200805092240.52875.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805092240.52875.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0901]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> disable the noisy print out. also use the one the less spare mtrr reg.

applied, thanks Yinghai.

	Ingo
