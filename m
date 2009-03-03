Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbZCCWIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbZCCWIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZCCWAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39387 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241AbZCCWAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Kalev Lember" <kalev@colleduc.ee>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.70B.5UarJB@chimera>
Subject: [Bug #12771] Oops in i915_gem_flush
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12771
Subject		: Oops in i915_gem_flush
Submitter	: Kalev Lember <kalev@colleduc.ee>
Date		: 2009-02-24 08:35 (8 days old)


