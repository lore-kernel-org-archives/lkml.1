Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZHIXlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZHIXlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZHIXlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:41:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbZHIXja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:39:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u1L1PAbl8zG.A.-3C.bj1fKB@chimera>
Subject: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 22:44:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


