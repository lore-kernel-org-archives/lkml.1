Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXICDse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXICDse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 23:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXICDsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 23:48:24 -0400
Received: from [212.12.190.47] ([212.12.190.47]:32854 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753323AbXICDsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 23:48:23 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, akpm@linux-foundation.org
Subject: Re: [GIT PULL -mm] Unionfs/fsstack/eCryptfs updates/cleanups/fixes
Date: Mon, 3 Sep 2007 06:48:20 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709030648.20267.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josef 'Jeff' Sipek wrote:
> The following is a series of patches related to Unionfs, which include
> three small VFS/fsstack patches and one eCryptfs patch; the rest are
> Unionfs patches.  The patches here represent several months of work and
> testing under various conditions, especially low-memory, SMP, and
> preemption situations with an assortment of lower systems: ext2/3/4, xfs,
> reiserfs, nfs, jffs2, ramfs, tmpfs, cramfs, and squashfs.

To increase test-usage, it may be critical to always backport at least to the 
latest stable release, like 2.6.22.


Thanks!

--
Al

