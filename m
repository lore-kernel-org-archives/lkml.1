Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZERR1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZERR1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZERR1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:27:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZERR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:27:24 -0400
Date: Mon, 18 May 2009 10:26:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mel Gorman <mel@csn.ul.ie>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebmunson@us.ibm.com
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
In-Reply-To: <20090518171322.GB13093@csn.ul.ie>
Message-ID: <alpine.LFD.2.01.0905181022420.3301@localhost.localdomain>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424095116.GB14283@csn.ul.ie> <1240586690.12551.31.camel@localhost> <20090430205919.GA24279@csn.ul.ie> <1241128126.29501.48.camel@pasglop> <20090518171322.GB13093@csn.ul.ie>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Mel Gorman wrote:
> 
> What's the story with this patch? I'm still hearing of failures with huge pages
> that this patch fixes but I'm no seeing it upstream. Was the patch
> rejected or did it just slip through the cracks?

It didn't slip through the cracks, it was apparently just delayed. It's 
part of the merge requests I've gotten today (well, strictly speaking it 
seems to have hit my inbox just before midnight yesterday, but that's 
because those silly aussies stand upside down and sleep at odd hours).

In fact, I just merged it, I haven't even had time to push that out. 

		Linus
