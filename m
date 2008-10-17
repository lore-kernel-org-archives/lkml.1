Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYJQIPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYJQIPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYJQIPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:15:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:15:00 -0400
Subject: Re: tracepoints for kernel/mutex.c
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       compudj@krystal.dyndns.org, fche@redhat.com, fweisbec@gmail.com,
       edwintorok@gmail.com, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081017140841.FAA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081016210430.GC25738@redhat.com>
	 <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
	 <20081017140841.FAA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 10:15:11 +0200
Message-Id: <1224231311.28131.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 14:09 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > Folks, lets please start by getting the tracing infrastructure in and
> > those few high-level trace-points google proposed.
> > 
> > Until we get the basics in, I think I'm going to NAK any and all
> > tracepoint/marker patches.
> 
> Could you please tell me how to get these patches?
> I'd like to review it.

I think writing is more the issue than reviewing here ;-)

