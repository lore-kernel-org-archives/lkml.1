Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZBKMEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZBKMEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZBKMEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:04:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbZBKME3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:04:29 -0500
Date: Wed, 11 Feb 2009 13:04:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090211120410.GC23873@elte.hu>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu> <20090210141052.GA5836@nowhere> <20090210142543.GF16147@elte.hu> <20090210144910.GE5836@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210144910.GE5836@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> Ok.
> I've dropped the build error example in the changelog, keeping only the reason
> of the error, as this is a V2.
> Tell me if you are fine with it.

Looks good - applied to tip:tracing/sysprof, thanks Frederic!

	Ingo
