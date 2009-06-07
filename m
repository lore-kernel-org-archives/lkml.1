Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZFGMzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZFGMzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZFGMxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:53:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbZFGMxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:53:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Vetter" <daniel@ffwll.ch>, "Len Brown" <len.brown@intel.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.AJ.ca7KKB@chimera>
Subject: [Bug #13277] 2.6.30 regression - unreliable resume - bisected - Thinkpad X40
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13277
Subject		: 2.6.30 regression - unreliable resume - bisected - Thinkpad X40
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2009-05-11 10:08 (28 days old)
Handled-By	: Len Brown <len.brown@intel.com>


