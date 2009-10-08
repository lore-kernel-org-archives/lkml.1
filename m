Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZJHTnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZJHTnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbZJHTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:43:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43911 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbZJHTnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:43:04 -0400
Date: Thu, 8 Oct 2009 14:42:27 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mimi Zohar <zohar@us.ibm.com>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.32-rc4
Message-ID: <20091008194222.GA26528@fedora-virt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0eca52a92735f43462165efe00a7e394345fb38e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Mimi Zohar (1):
      ima: ecryptfs fix imbalance message

Randy Dunlap (1):
      ecryptfs: depends on CRYPTO

Tyler Hicks (1):
      eCryptfs: Remove Kconfig NET dependency and select MD5

 fs/ecryptfs/Kconfig |    3 ++-
 fs/ecryptfs/main.c  |    7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)
