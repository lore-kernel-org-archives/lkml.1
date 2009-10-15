Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbZJOVPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbZJOVPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763079AbZJOVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:15:53 -0400
Received: from kroah.org ([198.145.64.141]:59017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763075AbZJOVPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:15:51 -0400
Date: Thu, 15 Oct 2009 14:11:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/3] 2.6.27.38-stable review
Message-ID: <20091015211112.GA5634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.38 release.
There are 3 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, October 18, 2009 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.38-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-----------

 Makefile                             |    2 +-
 drivers/scsi/scsi.c                  |   11 +++++++----
 drivers/usb/serial/digi_acceleport.c |    8 ++++----
 drivers/usb/serial/usb-serial.c      |    1 +
 4 files changed, 13 insertions(+), 9 deletions(-)
