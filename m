Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbXLCP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbXLCP6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLCP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:58:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLCP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:58:43 -0500
Date: Mon, 3 Dec 2007 16:57:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org
Subject: Re: [PATCH] isapnp driver semaphore to mutex
Message-ID: <20071203155753.GA32546@elte.hu>
References: <20071203153743.119714913@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203153743.119714913@mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> Changed the isapnp semaphore to a mutex.

cool - i'll give it a whirl.

small immaterial nit:

> Signed-Off-By: Daniel Walker <dwalker@mvista.com>

it's Signed-off-by (note the capitalization). Having this consistent 
makes scripting around patches a tiny bit easier.

	Ingo
