Return-Path: <linux-kernel-owner+w=401wt.eu-S933992AbZJMQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbZJMQJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760465AbZJMQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:09:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50157 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460AbZJMQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:09:42 -0400
Date: Tue, 13 Oct 2009 17:09:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 0/7] Introduce per cpu atomic operations and
	avoid per cpu address arithmetic
Message-ID: <20091013160909.GB18716@csn.ul.ie>
References: <20091007211024.442168959@gentwo.org> <20091013154020.GA18716@csn.ul.ie> <alpine.DEB.1.10.0910131145150.9478@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910131145150.9478@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 11:45:44AM -0400, Christoph Lameter wrote:
> On Tue, 13 Oct 2009, Mel Gorman wrote:
> 
> > FWIW, this fails to boot on latest mmotm on x86-64 even though the patches
> > apply. It fails to create basic slab cackes like kmalloc-64.
> 
> There was a fixup patch for one of the slub patches. Was that merged?
> 

No. I missed it without the change in subject line and had just exported
the thread series itself. Sorry.

I might have something useful on this in the morning assuming no other
PEBKAC-related messes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
