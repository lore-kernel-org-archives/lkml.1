Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXEYMPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXEYMPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXEYMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46503 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXEYMPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:04 -0400
Date: Fri, 25 May 2007 14:14:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, johnstul@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove clockevents_{release,request}_device
Message-ID: <20070525121433.GA13497@elte.hu>
References: <200705251404.23035.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705251404.23035.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Not called by anything in tree.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

thanks!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
