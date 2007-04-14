Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXDNVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXDNVcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXDNVcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:32:23 -0400
Received: from ariel.yandex.ru ([213.180.200.32]:47878 "EHLO ariel.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbXDNVcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:32:22 -0400
Date: Sun, 15 Apr 2007 01:32:04 +0400 (MSD)
From: "yantux" <yantux@yandex.ru>
Message-Id: <46214854.000001.22602@ariel.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: lkml <linux-kernel@vger.kernel.org>
Subject: Question about documentation for do_wait syscall ( and flags) and clone...
X-MsgDayCount: 1
X-BornDate: 1176494400
Reply-To: yantux@yandex.ru
X-Source-Ip: 212.129.105.207
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello community.

I use 2.6.17 gentoo.

Take my please reference to documentation, that discribe __WALL, __WNOTHREAD and __WALL flags for do_wait syscall.

Can be CLONE_THREAD flag (in do_fork syscall) effect to do_wait syscall with __WNOTHREAD (or __WALL) flag?

Best regards,
yantux.
