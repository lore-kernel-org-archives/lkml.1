Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZDBL00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZDBL00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZDBL0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:26:08 -0400
Received: from 8bytes.org ([88.198.83.132]:51469 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbZDBL0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:26:07 -0400
Date: Thu, 2 Apr 2009 13:26:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>, mingo <mingo@redhat.com>
Subject: Re: [PATCH] dma-debug: fix printk formats (i386)
Message-ID: <20090402112559.GC28667@8bytes.org>
References: <20090330140844.af1c9a1d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330140844.af1c9a1d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:08:44PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in dma-debug:
> 
> lib/dma-debug.c:645: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
> lib/dma-debug.c:662: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
> lib/dma-debug.c:676: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
> lib/dma-debug.c:686: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'

Applied, thanks.

	Joerg

