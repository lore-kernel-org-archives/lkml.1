Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZCCWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZCCWGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZCCWAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342AbZCCWAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael" <auslands-kv@gmx.de>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.x2B.7UarJB@chimera>
Subject: [Bug #12769] 3D performance gets very choppy after suspend/resume cycle (intel video)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12769
Subject		: 3D performance gets very choppy after suspend/resume cycle (intel video)
Submitter	: Michael <auslands-kv@gmx.de>
Date		: 2009-02-23 23:36 (9 days old)


