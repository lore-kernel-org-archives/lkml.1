Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXBNXJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXBNXJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXBNXJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:09:01 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36145 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801AbXBNXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:09:00 -0500
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20070214230855.0F43983226@kleikamp.austin.ibm.com>
Date: Wed, 14 Feb 2007 17:08:54 -0600 (CST)
From: shaggy@linux.vnet.ibm.com (Dave Kleikamp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I'm tired of seeing a warning every time jfs is compiled.  A similar patch
has been in jgarzik's misc-2.6.git#gccbug for a while now.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_txnmgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

through these ChangeSets:

Commit: c9e3ad6021e5eeb1c25cc4a573bd6427019a7a86 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Fri, 09 Feb 2007 15:36:47 -0600 

    JFS: Get rid of "may be used uninitialized" warnings
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

