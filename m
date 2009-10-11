Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZJKWZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZJKWZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZJKWZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:25:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZJKWZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Pavel Machek" <pavel@ucw.cz>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.OOE.9al0KB@chimera>
Subject: [Bug #14296] spitz boots but suspend/resume is broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
Subject		: spitz boots but suspend/resume is broken
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 12:06 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4


