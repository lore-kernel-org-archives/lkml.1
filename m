Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYCUMbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYCUMbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYCUMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbYCUMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:30:53 -0400
Date: Fri, 21 Mar 2008 13:30:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 04/10] sched: Add arch_update_cpu_topology hook.
Message-ID: <20080321123038.GI25225@elte.hu>
References: <20080312173155.703966894@de.ibm.com> <20080312173217.078548501@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312173217.078548501@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2973]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Will be called each time the scheduling domains are rebuild. Needed 
> for architectures that don't have a static cpu topology.

thanks, applied.

	Ingo
