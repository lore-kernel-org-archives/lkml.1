Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZCUTVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZCUTVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZCUTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:18:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZCUTSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:18:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, "Eric Anholt" <eric@anholt.net>,
       "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg@redhat.com>,
       "Nico Schottelius" <nico-linux-20090213@schottelius.org>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.8oB.oaTxJB@chimera>
Subject: [Bug #12705] X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12705
Subject		: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Submitter	: Nico Schottelius <nico-linux-20090213@schottelius.org>
Date		: 2009-02-13 9:33 (37 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e806b4957412bf472d826bd8cc571da041248799
References	: http://marc.info/?l=linux-kernel&m=123451768406825&w=4
		  http://marc.info/?l=linux-kernel&m=123479975503827&w=2
Handled-By	: Len Brown <lenb@kernel.org>


