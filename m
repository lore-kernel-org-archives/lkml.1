Return-Path: <linux-kernel-owner+w=401wt.eu-S1764007AbXGPXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764007AbXGPXyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:54:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:3606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=AcVnD0aYHVYj3CibMqtdsyzX0sszXsirxuZHvNec2cB+GLQrV4zj1BkVQQy3FEOTQ7NIS/zkapEcZfleeZgeFLzDjfMzvNyvPD+ipcxg15q6QMvCwfpFgYd2oUiuK8JN2ZKY3at0IREfX3X3Na+WRV0KwsXed/wgYYSvkQ3H05w=
Message-ID: <469C04F1.70000@googlemail.com>
Date: Tue, 17 Jul 2007 01:53:21 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: trivial@kernel.org
Subject: [PATCH] net/sched/Kconfig typo fixes
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some typo fixes in net/sched/Kconfig



Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 net/sched/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index d3f7c3f..8a74cac 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -97,7 +97,7 @@ config NET_SCH_ATM
       select classes of this queuing discipline.  Each class maps
       the flow(s) it is handling to a given virtual circuit.
 
-      See the top of <file:net/sched/sch_atm.c>) for more details.
+      See the top of <file:net/sched/sch_atm.c> for more details.
 
       To compile this code as a module, choose M here: the
       module will be called sch_atm.
@@ -137,7 +137,7 @@ config NET_SCH_SFQ
     tristate "Stochastic Fairness Queueing (SFQ)"
     ---help---
       Say Y here if you want to use the Stochastic Fairness Queueing (SFQ)
-      packet scheduling algorithm .
+      packet scheduling algorithm.
 
       See the top of <file:net/sched/sch_sfq.c> for more details.
 
@@ -306,7 +306,7 @@ config NET_CLS_RSVP6
       is important for real time data such as streaming sound or video.
 
       Say Y here if you want to be able to classify outgoing packets based
-      on their RSVP requests and you are using the IPv6.
+      on their RSVP requests and you are using the IPv6 protocol.
 
       To compile this code as a module, choose M here: the

       module will be called cls_rsvp6.



