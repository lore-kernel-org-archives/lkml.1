Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbYBOJCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbYBOJCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbYBOJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:01:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbYBOJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:01:55 -0500
Date: Fri, 15 Feb 2008 04:01:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, serue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall
	(v8)
Message-ID: <20080215090120.GA6266@infradead.org>
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214222103.a5d8f4fe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:21:03PM -0800, Andrew Morton wrote:
> Linus has just merged all the VFS renaming patches, so the decks
> are clear for looking at this work.
> 
> However David and Christoph are beavering away on the r-o-bind-mounts
> patches and I expect that there will be overlaps with unprivileged mounts.
> 
> Could we coordinate things a bit please?  Decide who goes first, review
> and maybe even test each others work, etc?

Al is setting up a git tree for VFS work.  per-mount r/o will go in
as one of the first things, aswell as his rework of the path lookup
logic to fix the intents mess.

> 
> Thanks.
---end quoted text---
