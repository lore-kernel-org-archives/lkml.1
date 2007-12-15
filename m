Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbXLOEHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbXLOEHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXLOEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:06:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58929 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXLOEGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:06:52 -0500
Date: Fri, 14 Dec 2007 20:05:36 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.11
Message-ID: <20071215040535.GA26274@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.11 kernel.
It fixes two build errors in the 2.6.23.10 kernel.  If you have no
problems with 2.6.23.10, then be happy and don't waste the electrons on
downloading another release.

I'll also be replying to this message with a copy of the patch between
2.6.23.10 and 2.6.23.11

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                     |    2 +-
 drivers/char/apm-emulation.c |   15 +++++++--------
 net/bridge/br_fdb.c          |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

Summary of changes from v2.6.23.10 to v2.6.23.11
================================================

Andrew Morton (1):
      BRIDGE: Section fix.

Greg Kroah-Hartman (2):
      Revert "Freezer: Fix APM emulation breakage"
      Linux 2.6.23.11

