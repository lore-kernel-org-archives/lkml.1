Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZGGOsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZGGOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZGGOsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:48:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbZGGOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:48:44 -0400
Date: Tue, 7 Jul 2009 10:48:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 1/4] fs: new truncate helpers
Message-ID: <20090707144842.GA3762@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707144423.GC2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:44:23PM +0200, Nick Piggin wrote:
> 
> Introduce new truncate helpers truncate_pagecache and inode_newsize_ok.
> vmtruncate is also consolidated from mm/memory.c and mm/nommu.c and
> into mm/truncate.c.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

