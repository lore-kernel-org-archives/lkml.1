Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbYL2QBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbYL2QBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYL2QB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:01:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44643 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYL2QB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:01:28 -0500
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20081229160115.7A98A4C9B71@norville.austin.ibm.com>
Date: Mon, 29 Dec 2008 10:01:15 -0600 (CST)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

through these ChangeSets:

commit d69e83d99cf87e3328c47bb54684360e32aef17d
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Tue Dec 16 10:21:34 2008 -0600

    jfs: ensure symlinks are NUL-terminated
    
    This is an alternate fix for a bug reported and fixed by Duane Griffin.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Reported-by: Duane Griffin <duaneg@dghda.com>
