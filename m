Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZBDNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZBDNC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbZBDMuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45066 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbZBDMux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.jNE.xuYiJB@chimera>
Subject: [Bug #12606] fb_mmap: circular locking dependency on hibernation
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12606
Subject		: fb_mmap: circular locking dependency on hibernation
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2009-01-27 18:37 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=123308162731408&w=4


