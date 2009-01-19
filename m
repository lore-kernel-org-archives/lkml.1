Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbZATATA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbZATATA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763337AbZATAGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:06:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763327AbZATAGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:06:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jean Delvare" <khali@linux-fr.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.UWB.ZJRdJB@chimera>
Subject: [Bug #12483] Reference to inexistent struct dmi_device_id breaks the build
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12483
Subject		: Reference to inexistent struct dmi_device_id breaks the build
Submitter	: Jean Delvare <khali@linux-fr.org>
Date		: 2009-01-19 01:29 (1 days old)


