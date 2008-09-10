Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYIMITz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYIMITz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYIMITo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:19:44 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58608 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbYIMITn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:19:43 -0400
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm@vger.kernel.org
Cc: Eric Miao <eric.miao@marvell.com>, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2008 10:07:34 +0200
Message-Id: <1221034056-16587-1-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: PXA fb overlay support (RESUBMIT 2).
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements the port of the old pxafb overlay support
for 2.6.22 to the latest kernel version.

It also adds the mmap() methods and fixes up an issue related to the
consistent memory allocation error which causes a segfault during
mmap().

Rodolfo


