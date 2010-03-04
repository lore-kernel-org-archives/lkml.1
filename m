Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0CDI0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:26:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0CDI0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:26:44 -0500
Date: Thu, 4 Mar 2010 13:54:50 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL] virtio-console fixes
Message-ID: <20100304082450.GA7844@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

While Rusty is away, I'm pushing these two small cleanup patches
directly to you.

There's no functional change; only stylistic fixes for better
readability.

The following changes since commit eaa5eec739637f32f8733d528ff0b94fd62b1214:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio-console.git master

Amit Shah (2):
      virtio: console: Fix type of 'len' as unsigned int
      virtio: console: Use better variable names for fill_queue operation

 drivers/char/virtio_console.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

		Amit
