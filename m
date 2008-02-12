Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbYBLJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbYBLJvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYBLJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:51:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:28293 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYBLJvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:51:44 -0500
Subject: [GIT-PULL] UBI updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Feb 2008 11:41:29 +0200
Message-Id: <1202809289.3127.9.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Feb 2008 09:44:34.0458 (UTC) FILETIME=[DFD1CFA0:01C86D5B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.infradead.org/~dedekind/ubi-2.6.git master

to receive few UBI updates and fixes.

Artem Bityutskiy (2):
      Documentation: add UBI sysfs ABI docs
      UBI: be verbose when debuggin is enabled

S.Çağlar Onur (1):
      UBI: silence warning

 Documentation/ABI/stable/sysfs-class-ubi |  212 ++++++++++++++++++++++++++++++
 drivers/mtd/ubi/debug.h                  |    2 +
 drivers/mtd/ubi/io.c                     |    4 +
 drivers/mtd/ubi/vmt.c                    |    4 +-
 4 files changed, 221 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-ubi

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

