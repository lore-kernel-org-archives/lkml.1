Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab0BHAwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:52:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab0BHApw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:45:52 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Feng Tang" <feng.tang@intel.com>, "Len Brown" <len.brown@intel.com>,
       "Lorenzo Buzzi" <flinco@libero.it>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.eNB.VZ1bLB@chimera>
Subject: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14886
Subject		: Asus P2B-DS not detected as SMP moterboard
Submitter	: Lorenzo Buzzi <flinco@libero.it>
Date		: 2009-12-27 17:20 (43 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
Handled-By	: Matthew Garrett <mjg59@srcf.ucam.org>
Patch		: http://patchwork.kernel.org/patch/76089/


