Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYLDAFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYLDAFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYLDACw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:02:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48432 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbYLDACt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:02:49 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Frederik Deweerdt" <frederik.deweerdt@gmail.com>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.V_H.OpxNJB@chimera>
Subject: [Bug #12047] ACPI toshiba: only register rfkill if bt is enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12047
Subject		: ACPI toshiba: only register rfkill if bt is enabled
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:10 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=122522113619025&w=2
Handled-By	: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122526843117478&w=2


