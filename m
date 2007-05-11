Return-Path: <linux-kernel-owner+w=401wt.eu-S966478AbXEKTx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966478AbXEKTx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030853AbXEKTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:50 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46664 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030812AbXEKTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:49 -0400
Message-ID: <4644C7AE.4000108@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:46 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: init/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fix in init/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index e8d080c..7ee2031 100644
--- a/init/main.c
+++ b/init/main.c
@@ -275,7 +275,7 @@ static int __init unknown_bootoption(char *param, char *val)
 		return 0;
 
 	/*
-	 * Preemptive maintenance for "why didn't my mispelled command
+	 * Preemptive maintenance for "why didn't my misspelled command
 	 * line work?"
 	 */
 	if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
-- 
1.5.0.1

-- 
Simon Arlott
