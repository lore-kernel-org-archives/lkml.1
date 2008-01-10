Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbYAJPMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbYAJPMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbYAJPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:08:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34446 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760628AbYAJPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:08:20 -0500
Date: Thu, 10 Jan 2008 15:08:08 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review
	(v2)
Message-ID: <20080110150808.GA32080@infradead.org>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 09:59:19AM -0500, Erez Zadok wrote:
> 
> Dear Linus, Al, Christoph, and Andrew,
> 
> As per your request, I'm posting for review the unionfs code (and related
> code) that's in my korg tree against mainline (v2.6.24-rc7-71-gfd0b45d).
> This is in preparation for merge in 2.6.25.

Huh?  There's still aboslutely not fix to the underlying problems of
the whole idea.   I think we made it pretty clear that unionfs is not
the way to go, and that we'll get the union mount patches clear once
the per-mountpoint r/o and unprivilegued mount patches series are in
and stable.


