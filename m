Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYKIT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYKIT4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYKITz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:55:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbYKITzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:55:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       =?utf-8?q?Fran=C3=A7ois=20Valenduc?= 
	<francois.valenduc@tvcablenet.be>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.14.15zFJB@chimera>
Subject: [Bug #11841] plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg and system not powering down
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
Subject		: plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg and system not powering down
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-10-25 10:29 (16 days old)
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://marc.info/?l=linux-acpi&m=122603281922125&w=4


