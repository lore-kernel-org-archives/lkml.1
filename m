Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab0CKRdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:33:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab0CKRc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kSe4zizQ8TCnMiQCCPKewB/HefD0vt6Xi2OfSoMhC+rKL8mSDMl52Yj5+VkgHfU8s8
         mnR8oKXP/b/xiGF0k1jgV9C5BKZl6lJpjTULgQokaojUbXhIHzcUxXpEZ73sQYOW4JSe
         yMjVACiFVbIvkzaGfiQ4rhZnJN4i7ecxH/0rA=
From: John D Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       John Sheehan <john.d.sheehan@gmail.com>
Subject: [PATCH] Staging: comedi: fix coding style in range.c
Date: Thu, 11 Mar 2010 17:32:33 +0000
Message-Id: <1268328753-8066-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

add missing space before closing brace

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/range.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 8313dfc..188c479 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -29,7 +29,7 @@ const struct comedi_lrange range_bipolar5 = { 1, {BIP_RANGE(5)} };
 const struct comedi_lrange range_bipolar2_5 = { 1, {BIP_RANGE(2.5)} };
 const struct comedi_lrange range_unipolar10 = { 1, {UNI_RANGE(10)} };
 const struct comedi_lrange range_unipolar5 = { 1, {UNI_RANGE(5)} };
-const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none}} };
+const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
 
 /*
 	COMEDI_RANGEINFO
-- 
1.6.3.3

