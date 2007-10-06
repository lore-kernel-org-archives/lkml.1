Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbXJFLR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbXJFLR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 07:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXJFLRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 07:17:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbXJFLRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 07:17:50 -0400
Date: Sat, 6 Oct 2007 13:17:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Dinakar Guniguntala <dino@in.ibm.com>,
       Cliff Wickman <cpw@sgi.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH v2] cpuset sched_load_balance flag
Message-ID: <20071006111723.GA32649@elte.hu>
References: <20071006094747.17518.44098.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006094747.17518.44098.sendpatchset@jackhammer.engr.sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Add a new per-cpuset flag called 'sched_load_balance'.
[...]

> See further the Documentation and comments in the code itself.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
