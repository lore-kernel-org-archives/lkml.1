Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYLDAJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYLDAJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYLDADb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:03:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbYLDAD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:03:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Mohr" <andi@lisas.de>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.3kH.9oxNJB@chimera>
Subject: [Bug #12100] resume (S2R) broken by Intel microcode module, on A110L
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:02 +0100 (CET)
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
Date		: 2008-11-25 08:48 (9 days old)


