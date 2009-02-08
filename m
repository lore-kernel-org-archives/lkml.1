Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZBHVyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZBHVyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZBHVs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:48:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbZBHVsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:48:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.xaG.-20jJB@chimera>
Subject: [Bug #12600] i915 lockdep warning
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12600
Subject		: i915 lockdep warning
Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date		: 2009-01-13 23:17 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4


