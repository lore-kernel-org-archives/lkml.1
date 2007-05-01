Return-Path: <linux-kernel-owner+w=401wt.eu-S1031626AbXEAJh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031626AbXEAJh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031627AbXEAJh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:37:56 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:13441 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031626AbXEAJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:37:56 -0400
Subject: Re: 2.6.22 -mm merge plans
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hch@lst.de, npiggin@suse.de
In-Reply-To: <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <84144f020705010217j738e461ey6b09fd738574fb70@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 11:37:50 +0200
Message-Id: <1178012270.24217.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 12:17 +0300, Pekka Enberg wrote:
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

I'll have another look at it; also, I'll try to work through Mel's
patches once again.

