Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZIIUgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZIIUgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZIIUgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:36:14 -0400
Received: from kroah.org ([198.145.64.141]:36234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZIIUgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:36:14 -0400
Date: Wed, 9 Sep 2009 13:33:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.33
Message-ID: <20090909203337.GA31676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.33 kernel.  It fixes a build
error with the ocfs2 filesystem.  If you do not use ocfs2, there is no
need to upgrade to this version, and 2.6.27.32 is sufficient.

I'll also be replying to this message with a copy of the patch between
2.6.27.32 and 2.6.27.33

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile        |    2 +-
 fs/ocfs2/aops.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (2):
      OCFS2: fix build error
      Linux 2.6.27.33

