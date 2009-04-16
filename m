Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZDQAc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZDQAc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759278AbZDQAcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:32:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759182AbZDQAcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:32:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Matthew Garrett" <mjg@redhat.com>,
       "Rodrigo L. Batista" <rodrigo@gus-mg.org>,
       "yakui_zhao" <yakui.zhao@intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.r2B.1w85JB@chimera>
Subject: [Bug #13048] /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:00 +0200 (CEST)
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
Date		: 2009-04-09 04:57 (8 days old)
Handled-By	: yakui_zhao <yakui.zhao@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20967
		  http://bugzilla.kernel.org/attachment.cgi?id=20959


