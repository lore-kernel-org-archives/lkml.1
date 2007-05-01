Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXEAT4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXEAT4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXEAT4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:56:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbXEAT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:56:22 -0400
Date: Tue, 1 May 2007 12:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-Id: <20070501125559.9ab42896.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 19:10:29 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> > Most of the rest of slub.  Will merge it all.
> 
> Merging slub already?  I'm surprised.

My thinking here is "does slub have a future".  I think the answer is
"yes", so we're reasonably safe getting it into mainline for the finishing
work.  The kernel.org kernel will still default to slab.

Does that sound wrong?

