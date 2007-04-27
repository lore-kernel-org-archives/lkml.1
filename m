Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXD0WGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXD0WGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXD0WF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:05:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49939 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbXD0WFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:05:21 -0400
Date: Fri, 27 Apr 2007 15:02:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.1
Message-ID: <20070427220216.GA2315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.1 kernel.
This release has two bugfixes for networking issues that should cause
all users of ipv4 or ipv6 to upgrade to this version.

I'll also be replying to this message with a copy of the patch between
2.6.21 and 2.6.21.1

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h

--------
 Makefile                |    2 +-
 net/ipv4/fib_frontend.c |    4 ++++
 net/ipv6/exthdrs.c      |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

Summary of changes from v2.6.21 to v2.6.21.1
============================================

Greg Kroah-Hartman (1):
      Linux 2.6.21.1

Sergey Vlasov (1):
      IPV4: Fix OOPS'er added to netlink fib.

YOSHIFUJI Hideaki (1):
      IPV6: Fix for RT0 header ipv6 change.

