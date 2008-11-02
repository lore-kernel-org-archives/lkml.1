Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYKBSB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYKBSB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYKBSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:00:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYKBSAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:00:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stefan Richter" <stefan-r-bz@s5r6.in-berlin.de>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.stH.KleDJB@chimera>
Subject: [Bug #11824] raw1394: possible deadlock if accessed by multithreaded app
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:06:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11824
Subject		: raw1394: possible deadlock if accessed by multithreaded app
Submitter	: Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
Date		: 2008-10-25 02:08 (9 days old)
Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11824#c3


