Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZFJFhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZFJFhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZFJFhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:37:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZFJFhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:37:10 -0400
Date: Wed, 10 Jun 2009 01:37:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
In-Reply-To: <4A2F1376.7040500@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906100135520.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <alpine.DEB.2.00.0906091531090.30552@gandalf.stny.rr.com> <4A2F1376.7040500@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Lai Jiangshan wrote:
> 
> I'm trying to write user-space tools. Could you tell me your tools'
> developing status? And the aim of these tools? Will it be public?

I'm toying with a command line parser, and something to hook with Ingo's 
perf.

> 
> I'm wandering whether I should stop this trying.

Well, more ideas the better, anything that is done can probably be used 
;-)

-- Steve

