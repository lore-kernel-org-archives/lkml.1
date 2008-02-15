Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbYBOUBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbYBOUBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYBOUBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:01:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbYBOUBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:01:17 -0500
Date: Fri, 15 Feb 2008 21:00:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 1/3] x86_64: CPA, fix cache attribute inconsistency
	bug, v2.6.22 backport
Message-ID: <20080215200024.GD15432@elte.hu>
References: <20080215195508.GA12405@elte.hu> <20080215195821.GA15432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215195821.GA15432@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0512]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


correction:

> fix CPA cache attribute bug in v2.6.23. When phys_base is nonzero
                                 v2.6.22

(the text says .23 but the fix is correctly against .22)

	Ingo
