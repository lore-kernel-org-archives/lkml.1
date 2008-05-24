Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbYEXVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbYEXVmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbYEXVdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:33:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762629AbYEXVdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:33:04 -0400
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Venki Pallipadi <"@ogre.sisk.pl,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.VVD.WeIOIB@albercik>
Subject: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10732
Subject		: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-05-17 7:32 (8 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121100994722524&amp;w=4


