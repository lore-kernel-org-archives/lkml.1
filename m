Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZBXA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZBXA1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZBXAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:20:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881AbZBXAU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:20:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Corentin Chary" <corentin.chary@gmail.com>,
       "Darren Salt" <linux@youmustbejoking.demon.co.uk>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "yakui_zhao" <yakui.zhao@intel.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.ptD.FpzoJB@chimera>
Subject: [Bug #12706] Oopses and ACPI problems (Linus 2.6.29-rc4)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12706
Subject		: Oopses and ACPI problems (Linus 2.6.29-rc4)
Submitter	: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date		: 2009-02-09 18:26 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=123420431709877&w=4
Patch		: http://marc.info/?l=linux-kernel&m=123427814117781&w=2


