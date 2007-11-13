Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbXKMUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbXKMUhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXKMUgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:36:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44751 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbXKMUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:36:48 -0500
Date: Tue, 13 Nov 2007 21:36:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Philip Mucci <mucci@cs.utk.edu>,
       eranian@hpl.hp.com, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113203645.GA17145@one.firstfloor.org>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113120728.4342e7d7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> He speaks for quite a few people - they have serious need for this feature

Most likely they have serious need for a very small subset of perfmon2.
The point of my proposal was to get this very small subset in quickly.

Phil, how many of the command line options of pfmon do you
actually use? How many do the people at your conference use? Or what
functions, what performance counters etc. in PAPI or whatever 
library you use? 

Make use understand the use cases better, that would already help a lot
in merging by concentrating on what people actually really need.

-Andi

