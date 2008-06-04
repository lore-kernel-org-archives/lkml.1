Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbYFDK0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbYFDK0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYFDK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:26:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYFDK0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:26:00 -0400
Date: Wed, 4 Jun 2008 12:25:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early check if one system is numaq v2
Message-ID: <20080604102544.GB22971@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806031025.55026.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0342]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> so could fallback one node numa
> v2: using found_numaq with MP_processor_info and MP_bus_info
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks.

	Ingo
