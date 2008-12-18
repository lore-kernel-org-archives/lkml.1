Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752888AbYLRUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYLRUjV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYLRUjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:39:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbYLRUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:39:03 -0500
Date: Thu, 18 Dec 2008 12:36:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, trond.myklebust@fys.uio.no,
        steved@redhat.com, rwheeler@redhat.com, bfields@fieldses.org,
        nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081218123601.11810b7f.akpm@linux-foundation.org>
In-Reply-To: <20081218142420.GA16728@infradead.org>
References: <8930.1229560221@redhat.com>
	<20081218224418.804f10bc.sfr@canb.auug.org.au>
	<20081218142420.GA16728@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 09:24:20 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Dec 18, 2008 at 10:44:18PM +1100, Stephen Rothwell wrote:
> > Added from today.
> > 
> > Usual spiel: all patches in that branch must have been
> > 	posted to a relevant mailing list
> > 	reviewed
> > 	unit tested
> > 	destined for the next merge window (or the current release)
> > *before* they are included.
> 
> I don't think we want fscache for .29 yet.  I'd rather let the
> credential code settle for one release, and have more time for actually
> reviewing it properly and have it 100% ready for .30.
> 

I don't believe that it has yet been convincingly demonstrated that we
want to merge it at all.

It's a huuuuuuuuge lump of new code, so it really needs to provide
decent value.  Can we revisit this?  Yet again?  What do we get from
all this?

