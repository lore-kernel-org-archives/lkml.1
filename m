Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbXJ3RRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbXJ3RRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXJ3RQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:16:54 -0400
Received: from xenotime.net ([66.160.160.81]:39309 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752511AbXJ3RQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:16:53 -0400
Date: Tue, 30 Oct 2007 10:16:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Message-Id: <20071030101650.73007bde.rdunlap@xenotime.net>
In-Reply-To: <20071030171436.GA15922@infradead.org>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu>
	<11936184592699-git-send-email-ezk@cs.sunysb.edu>
	<20071030095653.GC22413@infradead.org>
	<20071030082240.1ad71e6c.rdunlap@xenotime.net>
	<20071030171436.GA15922@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 17:14:36 +0000 Christoph Hellwig wrote:

> On Tue, Oct 30, 2007 at 08:22:40AM -0700, Randy Dunlap wrote:
> > They are just treated as part of the parameter explanation text.
> > I don't see any problem with them.
> 
> Well, it's completely inconsistant with any other kerneldoc..

True.  and it has an advantage.

---
~Randy
