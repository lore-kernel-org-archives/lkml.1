Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZGGAAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZGGAAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZGFX5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZGFX5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>, "Yinghai Lu" <yinghai@kernel.org>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.VeE.Z0oUKB@chimera>
Subject: [Bug #13690] nodes_clear cause hugepage unusable on non-NUMA machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13690
Subject		: nodes_clear cause hugepage unusable on non-NUMA machine
Submitter	: alexs <alex.shi@intel.com>
Date		: 2009-07-02 01:22 (5 days old)


