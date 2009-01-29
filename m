Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZA2N3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZA2N3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZA2N3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:29:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZA2N3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:29:05 -0500
Date: Thu, 29 Jan 2009 14:28:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] blktrace: Use tracing_reset_online_cpus
Message-ID: <20090129132852.GB24391@elte.hu>
References: <20090128143356.GG15877@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128143356.GG15877@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Impact: cleanup
> 
> Use tracing_reset_online_cpus instead of open coding it.
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 1b2267c..04d81d3 100644

Applied to tip/tracing/blktrace, thanks Arnaldo!

	Ingo
