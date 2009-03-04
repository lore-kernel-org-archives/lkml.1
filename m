Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZCDRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZCDRWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZCDRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:22:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZCDRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:22:41 -0500
Date: Wed, 4 Mar 2009 12:22:40 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for February 2009
Message-ID: <20090304172240.GA645@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In February various smaller fixes have been sent to Linus for 2.6.29,
including a revert of the faster vmap APIs which don't seem to be quite
ready yet on the VM side.  At the same time various patches have been
queued up for 2.6.30, with another big batch pending.  There also has
been a repost of the CRC patch series, including support for a new,
larger inode core.

SGI released various bits of work in progress from former employees
that will be extremely helpful for the future development of XFS,
thanks a lot to Mark Goodwin for making this happen.

On the userspace side the long awaited 3.0.0 releases of xfsprogs and
xfsdump finally happened early in the month, accompanies by a 2.2.9
release of the dmapi userspace.  There have been some issues with packaging
so a new minor release might follow soon.

The xfs_irecover tool has been relicensed so that it can be merged into
the GPLv2 codebase of xfsprogs, but the actual integration work hasn't
happened yet.

Important bits of XFS documentation that have been available on the XFS
website in PDF form have been released in the document source form under
the Creative Commons license so that they can be updates as a community
effort, and checked into a public git tree.
