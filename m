Return-Path: <linux-kernel-owner+w=401wt.eu-S2992665AbXCBRfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992665AbXCBRfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992670AbXCBRfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:35:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35582 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992665AbXCBRfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:35:51 -0500
Date: Fri, 2 Mar 2007 09:35:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070302093501.34c6ef2a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
	<45E842F6.5010105@redhat.com>
	<20070302085838.bcf9099e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 09:23:49 -0800 (PST) Christoph Lameter <clameter@engr.sgi.com> wrote:

> On Fri, 2 Mar 2007, Andrew Morton wrote:
> 
> > > Linux is *not* happy on 256GB systems.  Even on some 32GB systems
> > > the swappiness setting *needs* to be tweaked before Linux will even
> > > run in a reasonable way.
> > 
> > Please send testcases.
> 
> It is not happy if you put 256GB into one zone.

Oh come on.  What's the workload?  What happens?  system time?  user time?
kernel profiles?
