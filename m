Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZBCNaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZBCNaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZBCN37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:29:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41787 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZBCN36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:29:58 -0500
Date: Tue, 3 Feb 2009 11:29:28 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/3] trace: better manage the context info for
	events
Message-ID: <20090203132928.GE17781@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090202222921.GB12082@ghostprotocols.net> <20090203132616.GB29046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203132616.GB29046@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 03, 2009 at 02:26:16PM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Impact: make trace_event more convenient for tracers
> 
> i've applied your patchset to tip/tracing/bkltrace, thanks guys!
> 
> I see that there might be open questions still but it seems the principle 
> has been agreed upon and the patches were getting larger and harder to test 
> with each daym, so lets do the rest iteratively, ok?

Thanks a lot!

- Arnaldo
