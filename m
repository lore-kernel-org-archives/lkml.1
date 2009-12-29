Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZL2PTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZL2PTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZL2PTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:19:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZL2PNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>,
       "Mike Galbraith" <efault@gmx.de>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A._IH.RnhOLB@chimera>
Subject: [Bug #14923] Regression in 2.6.32.2: segfault on halt
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14923
Subject		: Regression in 2.6.32.2: segfault on halt
Submitter	: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Date		: 2009-12-19 15:10 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=126123574505069&w=4
Handled-By	: Mike Galbraith <efault@gmx.de>


