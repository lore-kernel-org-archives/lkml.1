Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbZBDNCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbZBDNCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZBDMut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679AbZBDMur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:47 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Sesterhenn" <snakebyte@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.2UE.zuYiJB@chimera>
Subject: [Bug #12605] Suspend regression, hang after matroxfb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12605
Subject		: Suspend regression, hang after matroxfb
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
Date		: 2009-01-29 12:58 (7 days old)
References	: http://thread.gmane.org/gmane.linux.power-management.general/12640
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=123335902122029&w=4


