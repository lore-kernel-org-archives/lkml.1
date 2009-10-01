Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZJAXXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZJAXXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZJAXXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:23:42 -0400
Received: from kroah.org ([198.145.64.141]:39696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbZJAXXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:04 2009
Message-Id: <20091001231633.719696398@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/9] 2.6.27.36-stable review
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.36 release.
There are 9 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, October 3, 2009 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.36-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

--------------

 Makefile                           |    2 +-
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
 drivers/net/enc28j60.c             |    4 +++-
 drivers/net/pcmcia/pcnet_cs.c      |    2 +-
 drivers/net/wireless/p54/p54usb.c  |    1 +
 fs/inode.c                         |   14 ++++++++------
 mm/hugetlb.c                       |    2 +-
 net/ax25/af_ax25.c                 |    2 +-
 net/bridge/br_netfilter.c          |    2 +-
 net/packet/af_packet.c             |    4 ++--
 10 files changed, 28 insertions(+), 21 deletions(-)

