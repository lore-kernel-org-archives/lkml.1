Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYKZFsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYKZFsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYKZFrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:47:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYKZFrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:47:51 -0500
Date: Wed, 26 Nov 2008 06:47:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace: add cpu annotation for function graph
	tracer
Message-ID: <20081126054728.GD9732@elte.hu>
References: <20081126051622.134970943@goodmis.org> <20081126051710.339437727@goodmis.org> <20081125213909.d4eb3f09.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125213909.d4eb3f09.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 26 Nov 2008 00:16:27 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch adds the annotation of 'CPU[###]' where ### is a three 
> > digit number
> 
> Is this a plot to get yourself sent a 1024-way test box?

So you are suggesting to change it to 4 digit printout?

(Is this a plot to get yourself snt a 16384-way test box? ;-)

	Ingo
