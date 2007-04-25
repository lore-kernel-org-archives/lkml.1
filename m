Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbXDYVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbXDYVZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXDYVZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:25:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59904 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbXDYVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:25:08 -0400
Date: Wed, 25 Apr 2007 14:22:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.8
Message-ID: <20070425212225.GA21200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.8 kernel.
This release has a security bugfix so any users of kernels older than
2.6.20.7 are highly encouraged to upgrade as soon as possible.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.7 and 2.6.20.8.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h

--------
 Makefile                |    2 +-
 net/ipv4/fib_frontend.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


Summary of changes from v2.6.20.7 to v2.6.20.8
==============================================

Alexey Kuznetsov (1):
      NETLINK: Infinite recursion in netlink.

Greg Kroah-Hartman (1):
      Linux 2.6.20.8

