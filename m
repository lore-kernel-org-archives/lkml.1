Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbZBYKEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbZBYKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZBYKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:04:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbZBYKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:04:44 -0500
Date: Wed, 25 Feb 2009 02:02:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090225020254.97be7715.akpm@linux-foundation.org>
In-Reply-To: <20090225095623.GB12352@elte.hu>
References: <20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	<20090224203308.8d623e0b.akpm@linux-foundation.org>
	<20090225081118.GC15303@elte.hu>
	<20090225002852.5ef5b869.akpm@linux-foundation.org>
	<84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
	<20090225012250.db68e480.akpm@linux-foundation.org>
	<1235554387.3849.30.camel@penberg-laptop>
	<20090225014442.7b7b7726.akpm@linux-foundation.org>
	<20090225095623.GB12352@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 10:56:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Since the concept of a kernel tracing facility being 
> self-sufficient and being easy to use is an integral and key 
> concept to ftrace, dont you see why people take your suggestions 
> as a dismissal of the ftrace concept?

Nothing I've suggested in any way makes ftrace hard to use.

If you guys had gone this way, you would not have screwed it up as much
as you're suggesting.

You're being unserious, and this is going nowhere.
