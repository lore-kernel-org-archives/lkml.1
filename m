Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYLAODi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYLAODi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYLAODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:03:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLAODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:03:30 -0500
Date: Mon, 1 Dec 2008 09:03:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: XFS status update for November 2008
Message-ID: <20081201140329.GA5257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mainline kernel is now at 2.6.28-rc6 and includes a small number of
XFS fixes.  There have been no updates to the XFS development tree during
December.  Without new regressions that large number of changes that
missed 2.6.28 has thus stabilized to be ready for 2.6.29.  In the meantime
kernel-side development has been slow, with the only major patch set
being a wide number of fixes to the compatibility for 32 bit ioctls on
a 64 bit kernel.

In the meantime there has been a large number of commits to the user space
tree, which mostly consist of smaller fixes.  xfsprogs is getting close
to have the 3.0.0 release which will be the first full resync with the
kernel sources since the year 2005.
