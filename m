Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYHXMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYHXMQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 08:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYHXMQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 08:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49958 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYHXMQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 08:16:24 -0400
Date: Sun, 24 Aug 2008 14:16:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] merge apic_32.c and apic_64.c
Message-ID: <20080824121607.GA22354@elte.hu>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
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


very nice series! I've applied it to tip/irq/sparseirq and did a 
test-integration with tip/master - lets see how it behaves in -tip 
testing.

	Ingo
