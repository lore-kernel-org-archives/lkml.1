Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbXHUEp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbXHUEp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbXHUEps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:45:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35164 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXHUEpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:45:47 -0400
Date: Mon, 20 Aug 2007 21:43:07 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.4
Message-ID: <20070821044307.GA13852@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.4 kernel.
It contains one security fix and all users of the 2.6.22 series are
encouraged to upgrade to it.

I'll also be replying to this message with a copy of the patch between
2.6.22.3 and 2.6.22.4

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile  |    2 +-
 fs/exec.c |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

Summary of changes from v2.6.22.3 to v2.6.22.4
==============================================

Greg Kroah-Hartman (1):
      Linux 2.6.22.4

Marcel Holtmann (1):
      Reset current->pdeath_signal on SUID binary execution (CVE-2007-3848)

