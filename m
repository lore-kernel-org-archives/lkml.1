Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYLLJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYLLJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbYLLJcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:32:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbYLLJcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:32:01 -0500
Date: Fri, 12 Dec 2008 10:31:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, cfriesen@nortel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sched: task group weight interface
Message-ID: <20081212093148.GL25106@elte.hu>
References: <20081210194048.464111787@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210194048.464111787@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Hi,
> 
> Dhaval poked me that he (and others) didn't like the weight interface 
> we currently have for task groups. I concurr and dusted off these old 
> patches.

applied to tip/sched/core, thanks Peter!

	Ingo
