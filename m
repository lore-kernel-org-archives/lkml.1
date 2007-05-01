Return-Path: <linux-kernel-owner+w=401wt.eu-S1031672AbXEALWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031672AbXEALWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031676AbXEALWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:22:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:60422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031672AbXEALWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:22:12 -0400
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hch@lst.de, npiggin@suse.de, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 May 2007 14:19:45 +0200
In-Reply-To: <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
Message-ID: <p73y7k8ybvi.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Pekka Enberg" <penberg@cs.helsinki.fi> writes:

> On 5/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >  revoke-special-mmap-handling.patch
> 
> [snip]
> 
> > Hold.  This is tricky stuff and I don't think we've seen sufficient
> > reviewing, testing and acking yet?
> 
> Agreed. While Peter and Nick have done some review of the patches, I
> would really like VFS maintainers to review them before merge.
> Christoph, have you had the chance to take a look at it?

Also have the cache performance concerns raised on the original review
been addressed?

-Andi
