Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYEEKRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYEEKRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYEEKRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:17:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43875 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbYEEKRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:17:01 -0400
Message-Id: <20080505101621.216789969@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 12:16:21 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 00/10] vfs: add helpers to check r/o bind mounts v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend of the path_* API patches.  This is against the VFS cleanup
patches posted recently.

Description is in the first patch header.

Changes from the previous submission:

 - rename() API is made more symmetric
 - all impacted vfs_* functions are made static

Comments (not just Al's) are welcome ;)

Thanks,
Miklos
