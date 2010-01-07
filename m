Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136Ab0AGPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0AGPxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007Ab0AGPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:53:46 -0500
Received: from kroah.org ([198.145.64.141]:54041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0AGPxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:53:45 -0500
Date: Thu, 7 Jan 2010 07:53:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.11
Message-ID: <20100107155300.GA15816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.11 kernel.  It fixes a build
error in the 2.6.31.10 kernel.  If you are using 2.6.31.10, and can 
build it properly, don't worry about updating to .11

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

Greg Kroah-Hartman (2):
      Revert "rt2x00: Disable powersaving for rt61pci and rt2800pci."
      Linux 2.6.31.11

