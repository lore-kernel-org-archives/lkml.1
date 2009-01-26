Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZAZRan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZAZRan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZAZRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:30:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbZAZRaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:30:35 -0500
Date: Mon, 26 Jan 2009 18:30:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip][1/1] Fixup checkpatch reported problems in ftrace
	plugin patch
Message-ID: <20090126173018.GA6238@elte.hu>
References: <20090126170056.GH1455@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126170056.GH1455@ghostprotocols.net>
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

> blktrace: Fixup checkpatch reported problems in ftrace plugin patch
>     
> Also make sure sparse (make C=2 block/blktrace.o) is happy too.

applied to tip/tracing/blktrace, thanks Arnaldo!

	Ingo
