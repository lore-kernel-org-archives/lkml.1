Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZBDMvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZBDMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBDMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44940 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZBDMtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:03 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.uoH.6vYiJB@chimera>
Subject: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:23:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
Subject		: ath5k related kernel panic in 2.6.29-rc1
Submitter	: Sergey S. Kostyliov <rathamahata@gmail.com>
Date		: 2009-01-12 7:38 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
Handled-By	: Bob Copeland <me@bobcopeland.com>


