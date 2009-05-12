Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZELUkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZELUkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZELUk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:40:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZELUk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:40:27 -0400
Date: Tue, 12 May 2009 16:40:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for April 2009
Message-ID: <20090512204027.GA2973@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In April development for Linux 2.6.30 was in full motion.  A patchset
to correct flushing of delayed allocations with near full filesystems
has been committed in early April, as well as various smaller fixes.
A patch series to improve the behavior of sys_sync has been posted
but is waiting for VFS changes queued for Linux 2.6.31.

On the userspace side xfsprogs and xfsdump 3.0.1 have managed to split their
release dates into May again after a lot of last-minute build system updates.
