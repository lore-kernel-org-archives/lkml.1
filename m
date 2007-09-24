Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbXIXUja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbXIXUja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXIXUjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:39:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45218 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXIXUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:39:21 -0400
Date: Mon, 24 Sep 2007 13:37:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-Id: <20070924133730.c9b7c0e6.randy.dunlap@oracle.com>
In-Reply-To: <46F80863.2090102@oracle.com>
References: <20070924164950.006047409@polymtl.ca>
	<20070924165428.335030720@polymtl.ca>
	<20070924175044.GD1608@infradead.org>
	<20070924105632.009aba7f.randy.dunlap@oracle.com>
	<20070924180041.GB2435@infradead.org>
	<20070924111318.f16cde07.randy.dunlap@oracle.com>
	<20070924181931.GA3810@infradead.org>
	<46F800A7.7090005@oracle.com>
	<20070924183042.GA4418@infradead.org>
	<46F806AB.1050509@oracle.com>
	<20070924185431.GA5618@infradead.org>
	<46F80863.2090102@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 11:56:35 -0700 Randy Dunlap wrote:

> Christoph Hellwig wrote:
> > On Mon, Sep 24, 2007 at 11:49:15AM -0700, Randy Dunlap wrote:
> >> I think that samples are perfectly fine for documentation and
> >> that the trace example is a good example.  I think that most people
> >> who need something like that would need to customize it for their
> >> specific needs anyway.
> >>
> >> We don't seem to be making progress...
> > 
> > Time to bring in a Tie-Breaker :)
> 
> Yes.  Is anyone else interested?   :(


I guess that's everyone (except those who are sleeping).

Let's not hold up progress.  Just use samples/ for code.

---
~Randy
Phaedrus says that Quality is about caring.
