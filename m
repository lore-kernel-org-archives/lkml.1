Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYKIUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYKIUH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYKIT5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908AbYKIT5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?Fran=C3=A7ois=20Valenduc?= 
	<francois.valenduc@tvcablenet.be>,
       "ykzhao" <yakui.zhao@intel.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.zrE.J4zFJB@chimera>
Subject: [Bug #11994] Computer doesn't power down after commit CPI: EC: do transaction from interrupt context
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11994
Subject		: Computer doesn't power down after commit CPI: EC: do transaction from interrupt context
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-11-09 02:02 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5ceb40417bca2045350e77f740e0c4c94875fff2
Handled-By	: ykzhao <yakui.zhao@intel.com>


