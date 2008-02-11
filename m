Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYBKGY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYBKGY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYBKGYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:24:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYBKGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:24:45 -0500
Date: Sun, 10 Feb 2008 22:22:24 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.2
Message-ID: <20080211062224.GA8476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.2
kernel.

It fixes one thing, CVE-2008-0600.

All users of the 2.6.24 series, with untrusted local users are strongly
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.24.1 and 2.6.24.2

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,

greg k-h

--------

 Makefile    |    2 +-
 fs/splice.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Summary of changes from v2.6.24.1 to v2.6.24.2
==============================================

Bastian Blank (1):
      splice: fix user pointer access in get_iovec_page_array()

Greg Kroah-Hartman (1):
      Linux 2.6.24.2

