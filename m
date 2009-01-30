Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZA3RV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZA3RV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZA3RVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:21:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZA3RVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:21:18 -0500
Date: Fri, 30 Jan 2009 15:21:02 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: better manage the context info for
	events
Message-ID: <20090130172102.GB8754@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4982c159.190c660a.7424.ffffabf9@mx.google.com> <alpine.DEB.1.10.0901301155300.6222@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901301155300.6222@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 30, 2009 at 11:56:41AM -0500, Steven Rostedt escreveu:
> 
> Frederic and Arnaldo,
> 
> I'm fine with this change. Are there other changes you are going to put on 
> top of this, or should I wait for new stuff before pulling it in and 
> sendingo it to Ingo?

Steve, please wait a bit, I'm reworking these changes so that they have
a first solid user in blktrace, I'll post it later today.

- Arnaldo
