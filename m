Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYB1Pm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYB1Pm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbYB1Pmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:42:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53459 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362AbYB1Pmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:42:50 -0500
Date: Thu, 28 Feb 2008 15:42:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Message-ID: <20080228154244.GA4038@csn.ul.ie>
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie> <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/02/08 22:29), Yinghai Lu didst pronounce:
> >  >
> >  > Did you get a chance to try out this patch to see if it cleared up the problem
> >  > booting on your x86_64 numa box?
> 
> did it fail with x86.git#testing?
> 

No, it boots successfully with that git branch. Somewhere in there is a fix.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
