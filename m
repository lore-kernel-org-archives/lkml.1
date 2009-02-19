Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZBSTT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZBSTT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZBSTTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:19:47 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35804 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753382AbZBSTTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:19:47 -0500
Date: Thu, 19 Feb 2009 13:19:42 -0600
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.29-rc6
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090219191942.EF635144A392D@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 402a917aca5daca69fcc91f43e6f1e6939cf393b:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Felix Blyakher (2):
      Revert "[XFS] use scalable vmap API"
      Revert "[XFS] remove old vmap cache"

 fs/xfs/linux-2.6/xfs_buf.c |   79 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 76 insertions(+), 3 deletions(-)
