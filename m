Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZLIFRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZLIFRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZLIFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:17:14 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:41099 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZLIFRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:17:10 -0500
Subject: CONFIG_FTRACE_STARTUP_TEST in 2.6.32
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 09 Dec 2009 00:17:11 -0500
Message-Id: <1260335831.3027.400.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

FYI I built a Linus tree yesterday with CONFIG_FTRACE_STARTUP_TEST
enabled (as well as *all* other debug options, per usual setup) on a KVM
instance running F12 userspace with otherwise "make localmodconfig".

The kernel stalls at the ftrace tester and I eventually rebooted it. I
didn't have any time to poke further, but I can do so if you don't
already know about this problem.

Jon.


