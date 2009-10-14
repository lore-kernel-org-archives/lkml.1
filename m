Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbZJNXIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbZJNXIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbZJNXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:08:11 -0400
Received: from kroah.org ([198.145.64.141]:41610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762137AbZJNXIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:08:09 -0400
Date: Wed, 14 Oct 2009 16:04:42 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fix for 2.6.32-git
Message-ID: <20091014230442.GD8865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one tty bugfix for your kernel tree.

It's been in the -next and -mm trees for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

The full patches will be sent to the linux-kernel mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/char/vt_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---------------

Andreas Schwab (1):
      tty: fix vt_compat_ioctl

