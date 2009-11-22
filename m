Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZKVPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZKVPW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZKVPW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:22:28 -0500
Received: from mx.treblig.org ([80.68.94.177]:53861 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZKVPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:22:27 -0500
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 10:22:27 EST
Date: Sun, 22 Nov 2009 14:53:15 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: lg@opensource.wolfsonmicro.com
Cc: trivial@kernel.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: [Patch] Trivial, Regulator docs cut-and-pasteism
Message-ID: <20091122145314.GA24475@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 14:42:17 up 6 days, 21:52,  1 user,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor copy-and-pasteism in the regulator docs (against
git from today):

  Signed-off-by: Dave Gilbert <linux@treblig.org>

diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
index 5f83fd2..cdebb51 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.txt
@@ -104,7 +104,7 @@ to set the limit to 500mA when supplying power.
 
 Consumers can control their supply current limit by calling :-
 
-int regulator_set_current_limit(regulator, min_uV, max_uV);
+int regulator_set_current_limit(regulator, min_uA, max_uA);
 
 Where min_uA and max_uA are the minimum and maximum acceptable current limit in
 microamps.

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
