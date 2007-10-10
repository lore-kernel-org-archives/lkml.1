Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXJJNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXJJNga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXJJNgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:36:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39100 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbXJJNgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:36:21 -0400
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20071010133542.D234E4C9AED@norville.austin.ibm.com>
Date: Wed, 10 Oct 2007 08:35:42 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_dtree.c |    8 ++------
 fs/jfs/jfs_dtree.h |    4 ++--
 fs/jfs/resize.c    |    2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

through these ChangeSets:

Commit: 2c5c37da093cd2f455ce818ee7b02b7a39d10498 
Author: Shaun Zinck <shaun.zinck@gmail.com> Fri, 31 Aug 2007 12:57:28 -0500 

    JFS: use DIV_ROUND_UP where appropriate
    
    This replaces some macros and code, which do the same thing as DIV_ROUND_UP
    defined in kernel.h, to use the DIV_ROUND_UP macro.
    
    Signed-off-by: Shaun Zinck <shaun.zinck@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 85e65c39f050a4964d0b943304bd896ff5375988 
Author: Jack Stone <jack@hawkeye.stone.uk.eu.org> Tue, 31 Jul 2007 09:36:53 -0500 

    Remove unnecessary kmalloc casts in the jfs filesystem
    
    Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

