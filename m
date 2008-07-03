Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYGCQrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYGCQrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYGCQrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:47:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129AbYGCQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:47:10 -0400
Date: Thu, 3 Jul 2008 09:46:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       babydr@baby-dragons.com, lee.schermerhorn@hp.com, a.beregalov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Do not clobber pgdat->nr_zones during memory
 initialisation
In-Reply-To: <alpine.LFD.1.10.0807030942440.18105@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807030944510.18105@woody.linux-foundation.org>
References: <20080701175855.GI32727@shadowen.org> <20080701190741.GB16501@csn.ul.ie> <1214944175.26855.18.camel@dwillia2-linux.ch.intel.com> <20080702051759.GA26338@csn.ul.ie> <1215049766.2840.43.camel@dwillia2-linux.ch.intel.com> <20080703042750.GB14614@csn.ul.ie>
 <alpine.LFD.1.10.0807022135360.18105@woody.linux-foundation.org> <20080703050036.GD14614@csn.ul.ie> <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com> <486CD623.8030906@linux-foundation.org> <20080703163638.GC18055@csn.ul.ie>
 <alpine.LFD.1.10.0807030942440.18105@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jul 2008, Linus Torvalds wrote:
>
> So it's now committed as follows..

Side note: master.kernel.org is going through maintenance today, so I 
haven't actually been able to push it out yet, in case anybody wonders why 
it's not showing up on the public sites.

It will all be out there later today.

			Linus
