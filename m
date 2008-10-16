Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYJPWPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYJPWPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYJPWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:15:00 -0400
Received: from www.tglx.de ([62.245.132.106]:53619 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbYJPWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:15:00 -0400
Date: Fri, 17 Oct 2008 00:14:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       compudj@krystal.dyndns.org, fche@redhat.com, fweisbec@gmail.com,
       edwintorok@gmail.com, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracepoints for kernel/mutex.c
In-Reply-To: <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.0810170013220.6848@apollo>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Peter Zijlstra wrote:
> On Thu, 2008-10-16 at 17:04 -0400, Jason Baron wrote:
> Folks, lets please start by getting the tracing infrastructure in and
> those few high-level trace-points google proposed.
> 
> Until we get the basics in, I think I'm going to NAK any and all
> tracepoint/marker patches.

Ditto.

	tglx
