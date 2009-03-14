Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbZCNVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbZCNVyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbZCNVoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:44:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbZCNVoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:44:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John Dykstra" <john.dykstra1@gmail.com>,
       "Thomas Backlund" <tmb@mandriva.org>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.DjC.O4BvJB@chimera>
Subject: [Bug #12869] BUG when disabled ipv6 module is unloaded
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:05:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12869
Subject		: BUG when disabled ipv6 module is unloaded
Submitter	: Thomas Backlund <tmb@mandriva.org>
Date		: 2009-03-10 20:15 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=123671614621097&w=4
Handled-By	: John Dykstra <john.dykstra1@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=123672746905127&w=4


