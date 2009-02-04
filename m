Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZBDMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZBDMwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZBDMtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbZBDMtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Peter Klotz" <peter.klotz@aon.at>,
       "Tero Roponen" <tero.roponen@gmail.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.edH.1vYiJB@chimera>
Subject: [Bug #12493] ACPI related kernel panic when booting 2.6.29-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:23:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12493
Subject		: ACPI related kernel panic when booting 2.6.29-rc2
Submitter	: Peter Klotz <peter.klotz@aon.at>
Date		: 2009-01-17 20:47 (19 days old)
References	: http://marc.info/?l=linux-acpi&m=123222565017047&w=4
Handled-By	: Alexey Starikovskiy <aystarik@gmail.com>
		  Tero Roponen <tero.roponen@gmail.com>
Patch		: http://marc.info/?l=linux-acpi&m=123223261225680&w=4


