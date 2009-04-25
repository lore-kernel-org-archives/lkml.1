Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZDYWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZDYWJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDYWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:09:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41587 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZDYWJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:09:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Matthew Garrett" <mjg@redhat.com>,
       "Rodrigo L. Batista" <rodrigo@gus-mg.org>,
       "yakui_zhao" <yakui.zhao@intel.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.XZF.De48JB@chimera>
Subject: [Bug #13048] /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:22:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13048
Subject		: /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
Submitter	: Rodrigo L. Batista <rodrigo@gus-mg.org>
Date		: 2009-04-09 04:57 (17 days old)
Handled-By	: yakui_zhao <yakui.zhao@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20967
		  http://bugzilla.kernel.org/attachment.cgi?id=20959


