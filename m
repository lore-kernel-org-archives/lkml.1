Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZD0Rg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZD0Rg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbZD0Rgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:36:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZD0Rgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:36:45 -0400
Date: Mon, 27 Apr 2009 18:36:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8] Sync fixes and cleanups (version 4)
Message-ID: <20090427173644.GE8633@ZenIV.linux.org.uk>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 04:43:47PM +0200, Jan Kara wrote:
>   Hi,
> 
>   here comes the next version of sync fixes and cleanups. This version also
> includes some moving of code from super.c to sync.c and quota sync cleanup and
> slight speedup. If noone has any objections anymore, who's going to merge it?
> Al?

Yes.  I've got the previous version of patchset in the local queue, BTW,
but I'm still going through that code.  Woke up to find the update...
