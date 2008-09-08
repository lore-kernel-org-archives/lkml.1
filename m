Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYIHNqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYIHNqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIHNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:46:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYIHNqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:46:36 -0400
Date: Mon, 8 Sep 2008 15:46:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86: little clean up intel.c/intel_64.c
Message-ID: <20080908134616.GD11993@elte.hu>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com> <1220835538-18280-9-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220835538-18280-9-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/kernel/cpu/intel.c    |    7 +++----
>  arch/x86/kernel/cpu/intel_64.c |    8 +++-----
>  2 files changed, 6 insertions(+), 9 deletions(-)

applied to tip/x86/unify-cpu-detect, thanks.

	Ingo
