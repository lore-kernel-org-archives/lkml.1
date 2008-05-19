Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbYESWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbYESWQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765231AbYESWKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:10:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40326 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765507AbYESWKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:10:06 -0400
Date: Tue, 20 May 2008 01:08:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/nfs/nfsroot.c: remove CVS keyword
Message-ID: <20080519220800.GQ17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a CVS keyword that wasn't updated for a long time 
from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b1b2f95e28139a739561c0f4257d9d36bee2d603 diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index 531379d..15afe3a 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -1,6 +1,4 @@
 /*
- *  $Id: nfsroot.c,v 1.45 1998/03/07 10:44:46 mj Exp $
- *
  *  Copyright (C) 1995, 1996  Gero Kuhlmann <gero@gkminix.han.de>
  *
  *  Allow an NFS filesystem to be mounted as root. The way this works is:

