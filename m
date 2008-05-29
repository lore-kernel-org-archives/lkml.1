Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYE2Ldu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYE2Ldu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYE2LdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56684 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYE2LdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:13 -0400
Message-Id: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:45 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 0/8] vfs: more cleanups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various cleanups and fixes.

This series is based on the vfs-cleanups(*) tree.  If no problems are
found, I'll commit the patches to that tree.

Thanks,
Miklos

(*) git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

--
