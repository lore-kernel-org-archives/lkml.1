Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYGZNAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYGZNAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYGZNAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:00:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYGZNAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:00:24 -0400
Date: Sat, 26 Jul 2008 15:00:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix IBM Summit based systems' phys_cpu_present_map on
	32-bit kernels
Message-ID: <20080726130012.GC5418@elte.hu>
References: <20080725020609.GB11800@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725020609.GB11800@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1077]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris McDermott <lcm@linux.vnet.ibm.com> wrote:

> x86 kernels on IBM Summit based systems will only online 1 CPU because 
> the phys_cpu_present_map is not set up correctly. Patch below applied 
> to 2.6.26-git10.

applied to tip/x86/urgent - thanks Chris!

	Ingo
