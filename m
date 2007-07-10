Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbXGJSrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbXGJSrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXGJSro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:47:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32980 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbXGJSrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:47:43 -0400
Date: Tue, 10 Jul 2007 11:47:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
In-Reply-To: <20070710135554.GC9426@skynet.ie>
Message-ID: <Pine.LNX.4.64.0707101147160.11906@schroedinger.engr.sgi.com>
References: <20070710102043.GA20303@skynet.ie> <20070710130356.GG8779@wotan.suse.de>
 <20070710135554.GC9426@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Mel Gorman wrote:

> > > >  These are slub changes which are dependent on Mel's stuff, and I have a note
> > > >  here that there were reports of page allocation failures with these.  What's
> > > >  up with that?

As far as I know these were resolved by some of Mel's changes.
