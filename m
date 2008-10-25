Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYJYWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYJYWCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYJYV7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:59:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbYJYV6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:58:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?utf-8?q?Fran=C3=A7ois=20Valenduc?= 
	<francois.valenduc@tvcablenet.be>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
In-Reply-To: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t1C3RWL0r7M.A.xSC.oV5AJB@chimera>
Subject: [Bug #11841] plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 22:06:46 +0200 (CEST)
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
Date		: 2008-10-25 10:29 (1 days old)


