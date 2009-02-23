Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZBXA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZBXA3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZBXAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:21:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004AbZBXAU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:20:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Marcelo Tosatti" <mtosatti@redhat.com>,
       "Tilman Schmidt" <t.schmidt@phoenixsoftware.de>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.-rC.vozoJB@chimera>
Subject: [Bug #12766] Lots of smp_processor_id() in preemptible messages
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12766
Subject		: Lots of smp_processor_id() in preemptible messages
Submitter	: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Date		: 2009-02-23 18:37 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123541536414019&w=4


