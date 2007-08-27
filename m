Return-Path: <linux-kernel-owner+w=401wt.eu-S1762309AbXH0UZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309AbXH0UZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbXH0UXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:07 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43328 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbXH0UW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:59 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>
Subject: nfs server patches for review
Date: Mon, 27 Aug 2007 16:22:41 -0400
Message-Id: <11882461763072-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These are some nfs server patches I intend to submit for 2.6.24.

I'm also keeping this sort of thing in the nfs-server-stable branch, at

	git://linux-nfs.org/~bfields/linux.git	nfs-server-stable

That repository has a bunch of random other (mainly nfs-related)
projects, but that particular branch is reserved for nfsd patches that I expect
to be ready in time for the next merge window.  If you have something
nfsd-related that I've overlooked, please let me know.

Nothing earth-shaking here right now, just minor cleanups, bugfixes, and
support from Peter Staubach for reporting 64 bit inode numbers.

--b.
