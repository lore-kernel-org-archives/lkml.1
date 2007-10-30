Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXJ3JPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXJ3JPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJ3JOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:14:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXJ3JOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:14:54 -0400
From: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Date: Tue, 30 Oct 2007 07:13:45 -0200
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create instrumentation directory (git repository)
Message-ID: <20071030091345.GA23268@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <pzijlstr@redhat.com>,
	Philippe Elie <phil.el@wanadoo.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"William L. Irwin" <wli@holomorphy.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071029233515.GA19413@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233515.GA19413@Krystal>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 29, 2007 at 07:35:15PM -0400, Mathieu Desnoyers escreveu:
> I see no good reason to have so many different adhoc instrumentation
> mechanisms for profiling (sched, vm, oprofile) and tracing (blktrace,
> suspend/resume tracing) all over the place. Merging them in a single
> directory seems like a good step towards a more generic
> instrumentation/profiling/tracing infrastructure.
> 
> Back to "profile" and "probes" directory names, they might be short, but
> they do not represent the whole markup-profiling-tracing trio,
> "profile" lacks the tracing part and "probe" lacks the markup part.

i14m
hooks

8)

- Arnaldo
