Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYAZUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYAZUXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYAZUXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:23:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51916 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYAZUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:23:39 -0500
Date: Sat, 26 Jan 2008 20:23:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] drop linux/ufs_fs.h from userspace export
Message-ID: <20080126202322.GC28444@infradead.org>
References: <200801260409.53276.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260409.53276.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 04:09:52AM -0500, Mike Frysinger wrote:
> Per previous discussions about cleaning up ufs_fs.h, people just want this
> straight up dropped from userspace export.  The only remaining consumer (silo)
> has been fixed a while ago to not rely on this header.

Thanks!  Care to move it to fs/ufs/ while you're at it?

