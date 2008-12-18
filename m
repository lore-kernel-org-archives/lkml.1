Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752144AbYLROYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbYLROYy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLROYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:24:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYLROYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:24:41 -0500
Date: Thu, 18 Dec 2008 09:24:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Howells <dhowells@redhat.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>, steved@redhat.com,
        rwheeler@redhat.com, bfields@fieldses.org, nfsv4@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-ID: <20081218142420.GA16728@infradead.org>
References: <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218224418.804f10bc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:44:18PM +1100, Stephen Rothwell wrote:
> Added from today.
> 
> Usual spiel: all patches in that branch must have been
> 	posted to a relevant mailing list
> 	reviewed
> 	unit tested
> 	destined for the next merge window (or the current release)
> *before* they are included.

I don't think we want fscache for .29 yet.  I'd rather let the
credential code settle for one release, and have more time for actually
reviewing it properly and have it 100% ready for .30.

