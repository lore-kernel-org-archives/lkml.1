Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYIVLDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYIVLDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYIVLCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:02:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYIVLCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:02:53 -0400
Date: Mon, 22 Sep 2008 13:02:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: cpu don't print duplicated vendor string
Message-ID: <20080922110229.GC5987@elte.hu>
References: <1221874876-12941-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221874876-12941-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0541]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Some CPUs have vendor string in the middle of model_id instead of 
> beginning

applied to tip/x86/core, thanks Yinghai.

	Ingo
