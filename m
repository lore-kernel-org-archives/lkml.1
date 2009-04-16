Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZDPUOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZDPUOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZDPUOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:14:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZDPUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:14:42 -0400
Date: Thu, 16 Apr 2009 16:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for March 2009
Message-ID: <20090416201426.GA6035@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linux 2.6.29 has been released which includes major XFS updates like the
new generic btree code, a fully functional 32bit compat ioctl implementation
and the new combined XFS and Linux inode.  (See previous status reports
for more details). A patch series to improve correctness and performance
has been posted but not yet applied.  Various minor fixes and cleanups
have been sent to Linus for 2.6.30 which looks like it will be a minor
release for XFS after the big churn in 2.6.29.

On userspace a lot of time has been spent on fixing and improving the
build system shared by the various XFS utilities as well as various smaller
improvements leading to the xfsprogs and xfsdump 3.0.1 releases which are
still outstanding.
