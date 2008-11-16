Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYKPSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYKPSex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYKPSeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYKPSeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:34:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tejun Heo" <tj@kernel.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.NRH.ECGIJB@chimera>
Subject: [Bug #11858] Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (22 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


