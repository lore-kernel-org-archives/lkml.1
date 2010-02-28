Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936389Ab0B1Sr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:47:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab0B1Sr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:47:27 -0500
Date: Sun, 28 Feb 2010 20:43:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Adam Litke <agl@us.ibm.com>, Amit Shah <amit.shah@redhat.com>,
       hch@lst.de, Jamie Lokier <jamie@shareable.org>,
       Shirley Ma <mashirle@us.ibm.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: [PULL] virtio
Message-ID: <20100228184341.GA32395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Rusty asked me to resolve any issues with virtio and lguest that
surface, so here comes.

Thanks!

The following changes since commit 847f9c606cad121cebf984639e3eeee1c4db82f8:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../geert/linux-m68k

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for-linus

Michael S. Tsirkin (1):
      virtio: fix out of range array access

 drivers/virtio/virtio_pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
MST
