Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZHBVyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZHBVyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZHBVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:50:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZHBVuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:50:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jean-Luc Coulon" <jean.luc.coulon@gmail.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.OpD.ZdgdKB@chimera>
Subject: [Bug #13770] System freeze on XFS filesystem recovery on an external disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13770
Subject		: System freeze on XFS filesystem recovery on an external disk
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2009-07-14 10:31 (20 days old)


