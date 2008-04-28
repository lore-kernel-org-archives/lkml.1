Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbYD1NaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbYD1NaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765277AbYD1NaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:30:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44626 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765600AbYD1NaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:30:08 -0400
Date: Mon, 28 Apr 2008 15:29:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 0/5] updates to ftrace framework and mmiotrace
Message-ID: <20080428132937.GB3973@elte.hu>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> Hello all,
> 
> here starts a little patch series that finally makes mmiotrace produce 
> good trace logs with the ftrace framework. There are some caveats 
> which I note below. Also, the marker feature (as in inserting user 
> comments into the log) is still missing.

thanks Pekka, applied.

	Ingo
