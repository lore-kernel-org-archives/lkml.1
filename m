Return-Path: <linux-kernel-owner+w=401wt.eu-S934578AbYBVEm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbYBVEm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbYBVEmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:42:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44497 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759348AbYBVEmP (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:42:15 -0500
Date: Fri, 22 Feb 2008 15:42:09 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.25-rc3
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 fs/xfs/Makefile-linux-2.6

through these commits:

commit 6e5e93424dc66542c548dfaa3bfebe30d46d50dd
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Fri Feb 22 15:36:19 2008 +1100

    Remove empty file fs/xfs/Makefile-linux-2.6.
