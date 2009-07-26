Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZGZXUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZGZXUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZGZXUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:20:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZGZXUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:20:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.muB.FHObKB@chimera>
Subject: [Bug #13840] KMS oops on 945G system
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13840
Subject		: KMS oops on 945G system
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2009-07-21 20:50 (6 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7662c8bd6545c12ac7b2b39e4554c3ba34789c50
References	: http://marc.info/?l=linux-kernel&m=124820945815030&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=commit;h=dff33cfcefa31c30b72c57f44586754ea9e8f3e2


