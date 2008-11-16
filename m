Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYKPSoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYKPSoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYKPSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:35:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43026 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbYKPSfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:35:40 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Badari Pulavarty" <pbadari@us.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.AEE.HAGIJB@chimera>
Subject: [Bug #12041] 2.6.28-rc4 mem_cgroup_charge_common panic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12041
Subject		: 2.6.28-rc4 mem_cgroup_charge_common panic
Submitter	: Badari Pulavarty <pbadari@us.ibm.com>
Date		: 2008-11-10 21:43 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122635343008147&w=4
Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


