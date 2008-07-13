Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYGMSUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYGMSUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYGMSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:20:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:40634 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYGMSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:20:30 -0400
Date: Sun, 13 Jul 2008 11:14:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.11
Message-ID: <20080713181412.GA450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.11
kernel.

It contains one bugfix, any user of the 2.6.25 kernel on x86-64 with
untrusted local users is very STRONGLY recommended to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.25.10 and 2.6.25.11

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile               |    2 +-
 include/asm-x86/desc.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Greg Kroah-Hartman (1):
      Linux 2.6.25.11

Michael Karcher (1):
      x86: fix ldt limit for 64 bit

