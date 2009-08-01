Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZHAE3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZHAE3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 00:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZHAE3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 00:29:12 -0400
Received: from kroah.org ([198.145.64.141]:36955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZHAE3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 00:29:12 -0400
Date: Fri, 31 Jul 2009 21:28:16 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] TTY: Maintainer change
Message-ID: <20090801042816.GA18467@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Clearly, I am a glutton for punishment.  I'll see if I can see Alan's
changes through to the end, otherwise I'll be fending off a lot of bug
reports for usb-serial devices.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

I have Alan's set of patches, and will be sending a addition-request
to linux-next to get them sucked into there starting next week.

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4995,7 +4995,9 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 
 TTY LAYER
-S:	Orphan
+M:	Greg Kroah-Hartman <gregkh@suse.de>
+S:	Maintained
+T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 F:	drivers/char/tty_*
 F:	drivers/serial/serial_core.c
 F:	include/linux/serial_core.h
