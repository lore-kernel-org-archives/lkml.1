Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKFQFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKFQFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKFQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:04:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYKFQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:04:53 -0500
Date: Thu, 6 Nov 2008 11:04:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for October 2008
Message-ID: <20081106160452.GA28042@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.27 released with all the bits covered in last month's report.  It
did however miss two important fixes for regressions that a few people hit.
2.6.27.3 or later are recommended for use with XFS.

In the meantime the generic btree implementation, the sync reorganization
and after a lot of merge pain the XFS and VFS inode unification hit the
development tree during the time allocated for the merge window.  No XFS
updates other than the two regression fixes also in 2.6.27.3 have made it
into mainline as of 2.6.28-rc3.

The only new feature on the list in October is support for the fiemap
interface that has been added to the VFS during the 2.6.28 merge window.
However there was lot of patch traffic consisting of fixes and respun
versions of previously known patches.  There still is a large backlog of
patches on the list that is not applied to the development tree yet.
