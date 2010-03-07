Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0CGKqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 05:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab0CGKqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 05:46:52 -0500
Date: Sun, 7 Mar 2010 12:42:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Adam Litke <agl@us.ibm.com>, Amit Shah <amit.shah@redhat.com>,
       hch@lst.de, Jamie Lokier <jamie@shareable.org>,
       Shirley Ma <mashirle@us.ibm.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>,
       Alexander Graf <agraf@suse.de>
Subject: [PULL] virtio
Message-ID: <20100307104252.GA19926@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Please pull another virtio fix: this one fixes hotplug and
was supposed to be applied by Rusty already
(http://lkml.org/lkml/2009/11/30/451), but apparently got lost,
somehow.

Thanks!

The following changes since commit 3119815912a220bdac943dfbdfee640414c0c611:
  Michael S. Tsirkin (1):
        virtio: fix out of range array access

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for-linus

Michael S. Tsirkin (1):
      virtio: set pci bus master enable bit

 drivers/virtio/virtio_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
