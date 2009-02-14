Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZBNXRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZBNXRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZBNXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:08:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZBNXH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Corentin Chary" <corentin.chary@gmail.com>,
       "Darren Salt" <linux@youmustbejoking.demon.co.uk>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "yakui_zhao" <yakui.zhao@intel.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.JmD.Rr0lJB@chimera>
Subject: [Bug #12706] Oopses and ACPI problems (Linus 2.6.29-rc4)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:23 +0100 (CET)
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
Date		: 2009-02-09 18:26 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=123420431709877&w=4


