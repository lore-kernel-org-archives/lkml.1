Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZLKNWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZLKNWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZLKNWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:22:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZLKNWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:22:06 -0500
Date: Fri, 11 Dec 2009 08:22:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for November 2009
Message-ID: <20091211132213.GA22342@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

November was a relatively slow month for XFS development.  The XFS tree
that is destined for the Linux 2.6.33 merge window saw a few fixes and
cleanups applied to it, and few important fixes still made it into the
last Linux 2.6.32 release candidates.  A few more patches including a
final version of the event tracing support for XFS were posted but not
reviewed yet.

On the userspace side there has been a fair amount of xfsprogs activity.
The repair speedup patches have finally been merged into the main development
branch and a couple of other fixes to the various utilities made it in, too.
The xfstests test suite saw another new regression test suite and a build
system fix up.
