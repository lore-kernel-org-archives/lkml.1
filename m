Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZAGKVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZAGKVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZAGKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:21:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60637 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZAGKV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:21:26 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 07 Jan 2009 10:21:59 +0000
Message-Id: <1231323719.3511.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following small fixes,

Steve.

-----------------------------------------------------------------------------------
The following changes since commit ede6f5aea054d3fb67c78857f7abdee602302043:
  Linus Torvalds (1):
        Fix up 64-bit byte swaps for most 32-bit architectures

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: Fix typo in gfs_page_mkwrite()

Steven Whitehouse (2):
      GFS2: Set GFP_NOFS when allocating page on write
      GFS2: LSF and LBD are now one and the same

 fs/gfs2/Kconfig       |    2 +-
 fs/gfs2/ops_address.c |    1 +
 fs/gfs2/ops_file.c    |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)


