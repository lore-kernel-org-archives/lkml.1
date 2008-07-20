Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYGTH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYGTH3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYGTH3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:29:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbYGTH3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:29:06 -0400
Date: Sun, 20 Jul 2008 09:28:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add pre_time_init in x86_ops
Message-ID: <20080720072858.GE32168@elte.hu>
References: <200807190207.26077.yhlu.kernel@gmail.com> <200807191802.26193.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191802.26193.yhlu.kernel@gmail.com>
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

> so numaq could use that to call numaq_pre_time_init
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks Yinghai.

	Ingo
