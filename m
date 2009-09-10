Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZIJGPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZIJGPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZIJGPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:15:24 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:46564 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZIJGPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:15:23 -0400
X-Greylist: delayed 704 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 02:15:23 EDT
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: srostedt@redhat.com
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH] tracing/events: Fixed typo
Date: Thu, 10 Sep 2009 08:02:21 +0200
Message-Id: <1252562541-32609-1-git-send-email-sojkam1@fel.cvut.cz>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 Documentation/trace/events.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index f157d75..8efb969 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -72,7 +72,7 @@ To enable all events in sched subsystem:
 
 	# echo 1 > /debug/tracing/events/sched/enable
 
-To eanble all events:
+To enable all events:
 
 	# echo 1 > /debug/tracing/events/enable
 
-- 
1.6.3.3

