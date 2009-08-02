Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZHBVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZHBVvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZHBVvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:51:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZHBVvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:51:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Paul Rolland" <rol@as2917.net>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.tsB.ocgdKB@chimera>
Subject: [Bug #13895] 2.6.31-rc4 - slab entry tak_delay_info leaking ???
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13895
Subject		: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Submitter	: Paul Rolland <rol@as2917.net>
Date		: 2009-07-29 08:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124884847925375&w=4


