Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYKPSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYKPSlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYKPSfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYKPSfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mircea Gherzan" <mgherzan@anaconda.cs.pub.ro>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.wpE.aAGIJB@chimera>
Subject: [Bug #12019] Major increase in the number of wakeups from C3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12019
Subject		: Major increase in the number of wakeups from C3
Submitter	: Mircea Gherzan <mgherzan@anaconda.cs.pub.ro>
Date		: 2008-11-13 07:02 (4 days old)


