Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZL2PRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZL2PRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZL2PP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:15:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZL2PPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:15:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Borislav Petkov" <petkovbb@googlemail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.rtF.7mhOLB@chimera>
Subject: [Bug #14948] EHCI resume sysfs duplicates
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:10:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14948
Subject		: EHCI resume sysfs duplicates
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:36 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=126182020615709&w=4


