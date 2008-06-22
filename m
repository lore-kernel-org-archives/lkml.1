Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYFVTSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYFVTSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYFVTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbYFVTFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:21 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "tosn00j02@sneakemail.com <"@ogre.sisk.pl
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.63G.4xpXIB@albercik>
Subject: [Bug #9791] Clock is running too fast^Wslow using acpi_pm clocksource
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (51 days old)
Handled-By	: Maciej W. Rozycki <macro@linux-mips.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16180


