Return-Path: <linux-kernel-owner+w=401wt.eu-S1765899AbYFGWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765899AbYFGWCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbYFGVsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578AbYFGVsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:40 -0400
Cc: "Tobias Diedrich" <ranma+kernel@tdiedrich.de>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.iWC.W2vSIB@albercik>
Subject: [Bug #10862] forcedeth: lockdep warning on ethtool -s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (7 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121230964032247&amp;w=4


