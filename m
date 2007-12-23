Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXLWHZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXLWHZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXLWHZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:25:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39195 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXLWHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:25:27 -0500
Date: Sat, 22 Dec 2007 23:24:18 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.24-rc5
Message-ID: <20071223072418.GA8764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and new device ids against your 2.6.24-rc6 git
tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 drivers/usb/gadget/fsl_usb2_udc.c |    2 +-
 drivers/usb/serial/cp2101.c       |    1 +
 drivers/usb/serial/sierra.c       |    2 ++
 3 files changed, 4 insertions(+), 1 deletions(-)

---------------

Kevin R Page (1):
      USB: VID/PID update for sierra

Martin Kusserow (1):
      USB: New device ID for the CP2101 driver

Peter Korsgaard (1):
      USB: Unbreak fsl_usb2_udc

