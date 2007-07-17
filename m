Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbXGQDLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbXGQDLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXGQDKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:10:50 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:59459 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXGQDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:10:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 23:10:49 EDT
Message-ID: <469C3178.9080701@pimpmylinux.org>
Date: Tue, 17 Jul 2007 05:03:20 +0200
From: Gabriel C <crazy@pimpmylinux.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: Re: [PATCH] net/sched/Kconfig typo fixes]
References: <469C2DAA.4090601@googlemail.com>
In-Reply-To: <469C2DAA.4090601@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Gabriel C <nix.or.die@googlemail.com>
> Date: Tue, 17 Jul 2007 01:53:21 +0200
> 
>> Some typo fixes in net/sched/Kconfig
>>
>>
>>
>> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> GMAIL has corrupted the patch, changing tabs into spaces
> among other things.  So the patch will not apply.
> 
> Please fix this up and resubmit.
> 

GMAIL is doing something strange right now :/

I hope this patch does work.


From: Gabriel Craciunescu <nix.or.die@googlemail.com>

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
 
-	  See the top of <file:net/sched/sch_atm.c>) for more details.
+	  See the top of <file:net/sched/sch_atm.c> for more details.
 
 	  To compile this code as a module, choose M here: the
 	  module will be called sch_atm.
@@ -137,7 +137,7 @@ config NET_SCH_SFQ
 	tristate "Stochastic Fairness Queueing (SFQ)"
 	---help---
 	  Say Y here if you want to use the Stochastic Fairness Queueing (SFQ)
-	  packet scheduling algorithm .
+	  packet scheduling algorithm.
 
 	  See the top of <file:net/sched/sch_sfq.c> for more details.
 
@@ -306,7 +306,7 @@ config NET_CLS_RSVP6
 	  is important for real time data such as streaming sound or video.
 
 	  Say Y here if you want to be able to classify outgoing packets based
-	  on their RSVP requests and you are using the IPv6.
+	  on their RSVP requests and you are using the IPv6 protocol.
 
 	  To compile this code as a module, choose M here: the
 	  module will be called cls_rsvp6.
