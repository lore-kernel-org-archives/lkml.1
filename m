Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZHBVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZHBVuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZHBVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:50:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbZHBVui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:50:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "ling.ma@intel.com" <ling.ma@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ma Ling" <ling.ma@intel.com>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.URD.OdgdKB@chimera>
Subject: [Bug #13819] system freeze when switching to console
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
Subject		: system freeze when switching to console
Submitter	: Reinette Chatre <reinette.chatre@intel.com>
Date		: 2009-07-23 17:57 (11 days old)


