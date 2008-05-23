Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYEWLth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYEWLth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYEWLtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:49:01 -0400
Received: from mg.nix.la ([75.126.232.227]:52185 "EHLO mg.nix.la"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYEWLst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:48:49 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2008 07:48:49 EDT
From: Anton Petrusevich <casus@casus.us>
To: linux-kernel@vger.kernel.org
Subject: PostgreSQL pgbench performance regression in 2.6.23+
Date: Fri, 23 May 2008 13:26:43 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231326.44247.casus@casus.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

>> I.e. i think it's a perfectly fine answer to say "if your workload needs 
>> batch scheduling, run it under SCHED_BATCH".
 
> Yes, and this appears to be such a case.
 
Excuse me for interrupting you, but am I getting this right: to run 
effectively PostgreSQL with an active web app on the server a "system 
administrator Joe" has to know about batch scheduling?
-- 
Anton Petrusevich
