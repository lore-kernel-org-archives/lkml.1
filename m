Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYIJGkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYIJGkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYIJGj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:39:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYIJGj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:39:56 -0400
Date: Wed, 10 Sep 2008 08:39:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: rename discontig_32.c to numa_32.c
Message-ID: <20080910063937.GD14700@elte.hu>
References: <1221028457-18954-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221028457-18954-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/core, thanks Yinghai.

	Ingo
