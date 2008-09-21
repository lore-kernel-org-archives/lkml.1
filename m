Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYIUUpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYIUUpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYIUUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:36:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbYIUUgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:36:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "" <jmerkey@wolfmountaingroup.com>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.q8G.g0q1IB@albercik>
Subject: [Bug #11549] 2.6.27-rc5 acpi: EC Storm error message on bootup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11549
Subject		: 2.6.27-rc5 acpi: EC Storm error message on bootup
Submitter	: <jmerkey@wolfmountaingroup.com>
Date		: 2008-09-02 21:27 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=122039255517586&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122098180019264&w=4


