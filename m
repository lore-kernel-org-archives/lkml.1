Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZBSJRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZBSJRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZBSJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:16:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbZBSJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:16:43 -0500
Date: Thu, 19 Feb 2009 10:16:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Message-ID: <20090219091616.GA3896@elte.hu>
References: <20090217182048.233060814@goodmis.org> <20090218000952.GD12714@elte.hu> <20090218084041.GA27540@elte.hu> <20090218163524.GA5858@nowhere> <20090219081728.GA15452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219081728.GA15452@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > But lockdep didn't say anything.
> > I'm reverting some of the last patches and will see.
> 
> Frederic, Steve, any progress on this bug? It's blocking all 
> new tracing patches.

ah, Steve found and fixed it - good.

	Ingo
