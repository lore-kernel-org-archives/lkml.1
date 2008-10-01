Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYJAUk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYJAUk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYJAUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:40:15 -0400
Received: from verein.lst.de ([213.95.11.210]:32863 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYJAUkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:40:13 -0400
Date: Wed, 1 Oct 2008 22:40:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for September 2008
Message-ID: <20081001204009.GA4259@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With Linux 2.6.27 still not released but only making slow progress from
2.6.27-rc5 to 2.6.27-rc8 XFS changes in mainline have been minimal in
September with only about half a dozen bug fixes patches.

In the meantime the generic btree patch set has been committed to the
development tree, but not many other updates yet.  On the user space side
xfsprogs 2.10.1 has been released on September 5th with a number of
important bug fixes.  Following the release of xfsprogs 2.10.1 open season
for development of the user space code has started.  The first full update
of the shared kernel / user space code in libxfs since 2005 has been
committed.  In addition to that the number of headers installed for the
regular devel package has been reduced to the required minimum and support
for checking the source code for endianess errors using sparse has been
added.

The patch sets to unify the XFS and Linux inode structures, and rewrite
various bits of the sync code have seen various iterations on the XFS
list, but haven't been committed yet.   A first set of patches implementing
CRCs for various metadata structures has been posted to the list.
