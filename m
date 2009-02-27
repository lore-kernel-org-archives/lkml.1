Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbZB0IHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbZB0IHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZB0IG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:06:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZB0IG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:06:56 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net
In-Reply-To: <20090227123806.1537.A69D9226@jp.fujitsu.com>
References: <20090227121053.152B.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0902262230130.19122@gandalf.stny.rr.com>
	 <20090227123806.1537.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 09:06:43 +0100
Message-Id: <1235722003.4948.1324.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 16:48 +0900, KOSAKI Motohiro wrote:

> I mean make the patch of mathieu's plan and mesure it. Then
> we can mesure number by number. my number mean,
> 
>   (1) How much increasing line and messiness
>   (2) How much improving latency
> 
> that's fairly comparision and typical lkml discussion style, imho.
> 
> What do you think?

Patches are welcome ;-)

