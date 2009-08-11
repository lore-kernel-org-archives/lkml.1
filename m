Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZHKRm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZHKRm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZHKRm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:42:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:43697 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZHKRm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:42:26 -0400
Date: Tue, 11 Aug 2009 11:39:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mel@csn.ul.ie>, Larry Woodman <lwoodman@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, Peter Zijlstra <peterz@infradead.org>,
       Li Ming Chun <macli@brc.ubc.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/6] tracing, documentation: Add a document describing
 how to do some performance analysis with tracepoints
Message-ID: <20090811113952.362d1f7d@bike.lwn.net>
In-Reply-To: <20090811113139.20bc276e@bike.lwn.net>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie>
	<1249918915-16061-6-git-send-email-mel@csn.ul.ie>
	<20090811113139.20bc276e@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 11:31:39 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> > +Documentation/trace/postprocess/trace-pagealloc-postprocess.pl is an example  
> 
> I don't have that file in current git...?

Duh, obviously, that's added by part 4 of the series.  Please ignore
this bit of noise, sorry.

jon
