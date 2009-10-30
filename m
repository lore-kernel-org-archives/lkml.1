Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbZJ3WKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbZJ3WKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbZJ3WJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:09:59 -0400
Received: from kroah.org ([198.145.64.141]:48369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZJ3WJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:09:52 -0400
Date: Fri, 30 Oct 2009 15:09:49 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fix for 2.6.32-git
Message-ID: <20091030220949.GD11297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one tty bugfix for your kernel tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

The full patch will be sent to the linux-kernel mailing list, if anyone
wants to see it.

thanks,

greg k-h

------------

 arch/m68k/Kconfig    |    6 +++---
 drivers/char/Kconfig |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

---------------

Alan Cox (1):
      tty: Mark generic_serial users as BROKEN

