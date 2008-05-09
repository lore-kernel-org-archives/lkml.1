Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbYEIMlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbYEIMlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYEIMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:41:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59640 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYEIMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:41:28 -0400
Message-Id: <20080509124107.645600519@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 09 May 2008 14:41:07 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/9] file locking fixes + fuse nfs export support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1-4 are file locking API changes required for the rest of the
patches.

Patches 5-9 add nfs exporting support for fuse filesystems.

This is for 2.6.27.

Thanks,
Miklos

--
