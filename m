Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZHLNMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZHLNMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZHLNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:12:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37185 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZHLNMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:12:14 -0400
Date: Wed, 12 Aug 2009 14:12:12 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Fernando Carrijo <fcarrijo@yahoo.com.br>
Cc: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>, Li Ming Chun <macli@brc.ubc.ca>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] tracing, documentation: Add a document describing
	how to do some performance analysis with tracepoints
Message-ID: <20090812131212.GC19269@csn.ul.ie>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie> <1249918915-16061-6-git-send-email-mel@csn.ul.ie> <1250039059.4838.13.camel@pc-fernando>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1250039059.4838.13.camel@pc-fernando>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:04:19PM -0300, Fernando Carrijo wrote:
> > <SNIP>
> > +At a glance, it looks like the time is being spent copying pixmaps to
> > +the card.  Further investigation would be needed to determine why pixmaps
> > +are being copied around so much but a starting point would be to take an
> > +ancient build of libpixmap out of the library path where it was totally
>                     ^^^^^^^^^
> 
> libpixman, right?
> 

Yep. Thanks

> > +forgotten about from months ago!
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
