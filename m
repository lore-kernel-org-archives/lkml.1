Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYLGWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYLGWlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYLGWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:38:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896AbYLGWi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:38:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Mohr" <andi@lisas.de>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
In-Reply-To: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <07Xes05z25M.A.QvF.qsEPJB@chimera>
Subject: [Bug #12100] resume (S2R) broken by Intel microcode module, on A110L
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:32:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12100
Subject		: resume (S2R) broken by Intel microcode module, on A110L
Submitter	: Andreas Mohr <andi@lisas.de>
Date		: 2008-11-25 08:48 (13 days old)


