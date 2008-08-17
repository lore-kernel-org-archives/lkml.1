Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYHQQav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYHQQav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHQQan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:30:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYHQQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:30:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.27-rc3-git3: Reported regressions from 2.6.26
Date: Sun, 17 Aug 2008 18:33:51 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <20080817135134.GA8162@mit.edu>
In-Reply-To: <20080817135134.GA8162@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171833.52278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Theodore Tso wrote:
> On Sat, Aug 16, 2008 at 09:00:39PM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11341
> > Subject		: 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size of Inode
> > Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date		: 2008-08-13 6:56 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121861058720051&w=4
> 
> This wasn't a regression because it wasn't a kernel bug (and so by
> definition it existed on prior kernel versions :-).  I've just checked
> in a fix into the e2fsprogs repository, and I've included the
> e2fsprogs patch in the bugzilla record for the user's convenience.

Thanks a lot for handling this.

Rafael
