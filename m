Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYJUUK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYJUUK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYJUUKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:10:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42762 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYJUUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:10:16 -0400
Date: Tue, 21 Oct 2008 14:10:12 -0600
From: dann frazier <dannf@hp.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] cciss: Add P700m to list of supported controllers
Message-ID: <20081021201012.GB13772@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P700m support was added in:
  9cff3b383dad193b0762c27278a16237e10b53dc

Update cciss.txt to match.

Signed-off-by: dann frazier <dannf@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
---
 Documentation/cciss.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/cciss.txt b/Documentation/cciss.txt
index 8244c64..802c3c0 100644
--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -21,6 +21,7 @@ This driver is known to work with the following cards:
 	* SA E200
 	* SA E200i
 	* SA E500
+	* SA P700m
 	* SA P212
 	* SA P410
 	* SA P410i
-- 
1.5.6.5

