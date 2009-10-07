Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZJGWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZJGWAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZJGWAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:00:15 -0400
Received: from kroah.org ([198.145.64.141]:41218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZJGWAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:00:13 -0400
Date: Wed, 7 Oct 2009 14:56:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.3
Message-ID: <20091007215607.GC7241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.3 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

There was a bug in the tty layer that a number of users were hitting in
2.6.31.2, so everyone should upgrade.

Thank to Alan Stern for pointing out the mistake, my fault for not
picking up a patch for 2.6.31.2.

I'll also be replying to this message with a copy of the patch between
2.6.31.2 and 2.6.31.3

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                |    2 +-
 drivers/char/tty_port.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Alan Stern (1):
      TTY: fix typos

Greg Kroah-Hartman (1):
      Linux 2.6.31.3

