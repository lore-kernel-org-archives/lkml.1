Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZBDMxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZBDMxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZBDMtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZBDMtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:05 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.ciH.4vYiJB@chimera>
Subject: [Bug #12491] i915 lockdep warning
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12491
Subject		: i915 lockdep warning
Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
Date		: 2009-01-13 23:17 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4


