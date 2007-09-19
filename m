Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXISMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXISMg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXISMgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:36:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52364 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbXISMgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:36:47 -0400
Subject: LTP Latest Snapshot now available
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: IBM
Date: Wed, 19 Sep 2007 18:06:42 +0530
Message-Id: <1190205402.28382.38.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
You can pick up LTP latest snapshot
(ltp-nightly-snapshot_19-09-2007.tgz) from:
http://sourceforge.net/project/showfiles.php?group_id=3382&package_id=3308&release_id=535958

It differs from earlier snapshot (ltp-nightly-snapshot_07-09-2007.tgz)
by:
1) runltp fix for generation of default failed file under output
directory,
2) Fix for Memory testcase mem02, fix for var_args expander in
lib/tst_res.c and a small fix in open_posit_testsuite.

--Subrata--


