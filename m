Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYC1QnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYC1QnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYC1QnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:43:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbYC1QnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:43:05 -0400
Date: Fri, 28 Mar 2008 17:42:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: gorcunov@gmail.com
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] x86 flags cleanup
Message-ID: <20080328164247.GA19247@elte.hu>
References: <20080328145655.076024373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328145655.076024373@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1777]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* gorcunov@gmail.com <gorcunov@gmail.com> wrote:

> This patch series does remove some flags from x86.h. We should better
> use ones from processor-flags.h

thanks Cyrill, applied.

	Ingo
