Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKBSDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKBSDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYKBSBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:01:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYKBSBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:01:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?Fran=C3=A7ois=20Valenduc?= 
	<francois.valenduc@tvcablenet.be>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.wNH.3keDJB@chimera>
Subject: [Bug #11841] plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
Subject		: plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-10-25 10:29 (9 days old)


