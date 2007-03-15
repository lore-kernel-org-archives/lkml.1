Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbXCOUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbXCOUXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbXCOUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:23:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49596 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933812AbXCOUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:23:52 -0400
Date: Thu, 15 Mar 2007 13:23:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: nickpiggin@yahoo.com.au, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
In-Reply-To: <20070313043051.498ede98.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703151315430.27311@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
 <20070313005334.853559ca.akpm@linux-foundation.org> <45F65ADA.9010501@yahoo.com.au>
 <20070313035250.f908a50e.akpm@linux-foundation.org> <45F685C6.8070806@yahoo.com.au>
 <20070313041551.565891b5.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703130418320.5720@schroedinger.engr.sgi.com>
 <20070313043051.498ede98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Andrew Morton wrote:

> > On Tue, 13 Mar 2007 04:20:48 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > On Tue, 13 Mar 2007, Andrew Morton wrote:
> > 
> > > Yeah, prezeroing in idle is probably pointless.  But I'm not aware of
> > > anyone having tried it properly...
> > 
> > Ok, then what did I do wrong 3 years ago with the prezeroing patchsets?
> 
> Failed to provide us a link to it?

You merged part of it and were involved in the discussions.

General overviews:

http://lwn.net/Articles/117881/
http://lwn.net/Articles/128225/

The details on the problems with prezeroing and touching multiple 
cachelines of the page.

http://www.gelato.unsw.edu.au/archives/linux-ia64/0412/12252.html

