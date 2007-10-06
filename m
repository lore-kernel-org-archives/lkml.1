Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbXJFS3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbXJFS3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763854AbXJFS2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:28:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763637AbXJFS2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:28:47 -0400
Message-Id: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:02 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 0/9] compat_ioctl: introduce block/compat_ioctl.c
X-Provags-ID: V01U2FsdGVkX18D8hpV2nR0Tn8e5zjQ8NkKDHNtyxCSIqC/Ym0
 ZkBKCHcFAq2EQ9IoFT157jObnYkIKKEc3Hwfx16aWXoWP/f9D1
 M9H1coKHfDDbmXvby5B4Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is my block ioctl series split up into managable chunks. I'm not
really sure about the last two of these, I'd prefer to get a second
opinion on those.

Please apply once your tests have gone though.

	Arnd <><

