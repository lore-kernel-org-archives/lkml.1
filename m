Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbXJ3ROx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbXJ3ROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXJ3ROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:14:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46905 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXJ3ROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:14:43 -0400
Date: Tue, 30 Oct 2007 17:14:36 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christoph Hellwig <hch@infradead.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Message-ID: <20071030171436.GA15922@infradead.org>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu> <11936184592699-git-send-email-ezk@cs.sunysb.edu> <20071030095653.GC22413@infradead.org> <20071030082240.1ad71e6c.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030082240.1ad71e6c.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 08:22:40AM -0700, Randy Dunlap wrote:
> They are just treated as part of the parameter explanation text.
> I don't see any problem with them.

Well, it's completely inconsistant with any other kerneldoc..


