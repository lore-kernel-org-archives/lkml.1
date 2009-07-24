Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZGXWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZGXWaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZGXWap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:30:45 -0400
Received: from kroah.org ([198.145.64.141]:46276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbZGXWaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:30:04 -0400
Date: Fri, 24 Jul 2009 15:29:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.3
Message-ID: <20090724222900.GC30562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.3 kernel.  It fixes a boot
problem that people reported in the 2.6.30.2 release.  If you don't have
this problem, don't worry about upgrading.

I'll also be replying to this message with a copy of the patch between
2.6.30.2 and 2.6.30.3

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile              |    2 +-
 drivers/video/fbmon.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


Greg Kroah-Hartman (1):
      Linux 2.6.30.3

Linus Torvalds (1):
      fbmon: work around compiler bug in gcc-4.2.4

