Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295Ab0ANHSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0ANHSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957Ab0ANHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:18:27 -0500
Received: from mail.perches.com ([173.55.12.10]:1174 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0ANHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:26 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/24] MAINTAINERS: INPUT DRIVERS - Add "Q" patchwork entry
Date: Wed, 13 Jan 2010 23:13:09 -0800
Message-Id: <74fea6defb62d1a2c8ed2fa1ea2d5baaf6b87c5d.1263452909.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263452908.git.joe@perches.com>
References: <cover.1263452908.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d42fb8c..8c7505e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2758,6 +2758,7 @@ INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
 M:	Dmitry Torokhov <dtor@mail.ru>
 L:	linux-input@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-input/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
-- 
1.6.6.rc0.57.gad7a

