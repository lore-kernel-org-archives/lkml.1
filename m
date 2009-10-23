Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZJWA7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZJWA7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 20:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZJWA7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 20:59:37 -0400
Received: from kroah.org ([198.145.64.141]:39491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZJWA7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:59:37 -0400
Date: Thu, 22 Oct 2009 17:36:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.38
Message-ID: <20091023003633.GA23961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.38 kernel.  All users of the
2.6.27 kernel series that use SCSI devices, or USB to serial devices are
very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 drivers/scsi/scsi.c                  |   11 +++++++----
 drivers/usb/serial/digi_acceleport.c |    8 ++++----
 drivers/usb/serial/usb-serial.c      |    1 +
 4 files changed, 13 insertions(+), 9 deletions(-)


Alan Stern (1):
      usb-serial: fix crash when sub-driver updates firmware

Greg Kroah-Hartman (1):
      Linux 2.6.27.38

Johan Hovold (1):
      USB: digi_acceleport: Fix broken unthrottle.

Martin K. Petersen (1):
      SCSI: Fix protection scsi_data_buffer leak

