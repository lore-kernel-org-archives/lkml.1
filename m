Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZBXATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZBXATW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZBXATI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:19:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZBXATF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:19:05 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Roland Dreier" <rolandd@cisco.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.8rF.0qzoJB@chimera>
Subject: [Bug #12491] i915 lockdep warning
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12491
Subject		: i915 lockdep warning
Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date		: 2009-01-13 23:17 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4
Handled-By	: Roland Dreier <rolandd@cisco.com>
Patch		: http://marc.info/?l=linux-kernel&m=123378709730700&w=2


