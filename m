Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbYEaAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbYEaAEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYEaADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:03:14 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:59014
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbYEaADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:03:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 5] xen device driver updates [resend]
Message-Id: <patchbomb.1212192090@localhost>
Date: Sat, 31 May 2008 01:01:30 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Repost spelling Jeff's email addr properly. ]

This is a series of cleanups to xen-blkfront, xen-netfront and xenbus.
They're mostly changes imported from the linux-2.6.18-xen repo because
they looked like they would be useful.

Thanks,
	J

 drivers/block/xen-blkfront.c       |   48 ++++++++++++++++++++++++++---
 drivers/net/xen-netfront.c         |    4 +-
 drivers/xen/xenbus/xenbus_client.c |    2 -
 drivers/xen/xenbus/xenbus_xs.c     |   10 +++---
 4 files changed, 52 insertions(+), 12 deletions(-)


