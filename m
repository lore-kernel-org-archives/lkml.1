Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbYD2Uwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbYD2Uwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYD2Uwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:52:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbYD2Uwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:52:36 -0400
Date: Tue, 29 Apr 2008 22:52:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mmiotrace: rename kmmio_probe::user_data to
	:private.
Message-ID: <20080429205214.GA22298@elte.hu>
References: <20080428214504.5c359195@daedalus.pq.iki.fi> <20080429234021.071f7948@daedalus.pq.iki.fi> <20080429234648.650227e9@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429234648.650227e9@daedalus.pq.iki.fi>
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


thanks Pekka, applied all 3 patches.

	Ingo
