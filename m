Return-Path: <linux-kernel-owner+w=401wt.eu-S965822AbXFFXHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822AbXFFXHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965205AbXFFXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:07:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965101AbXFFXHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:07:05 -0400
Date: Thu, 7 Jun 2007 01:06:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
Message-ID: <20070606230641.GA11592@elte.hu>
References: <1181165656.7133.23.camel@dix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181165656.7133.23.camel@dix>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Martin Peschke <mp3@de.ibm.com> wrote:

> The output has changed from a terribly wide table to an enormously 
> long list (just the generic way the statistics code prints data). 

Sigh, why dont you _ask_ before doing such stuff? It is a terribly wide 
table because that makes it easily greppable but still watchable in one 
chunk in a sufficiently zoomed out xterm. Please preserve this output 
format, quite some work went into it - NACK :-(

	Ingo
