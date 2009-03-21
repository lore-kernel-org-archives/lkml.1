Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZCUTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZCUTsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZCUTqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:46:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbZCUTqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:46:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Doug Bazarnic" <doug@bazarnic.net>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.y0F.08TxJB@chimera>
Subject: [Bug #12421] GPF on 2.6.28 and 2.6.28-rc9-git3, e1000e and e1000 issues
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12421
Subject		: GPF on 2.6.28 and 2.6.28-rc9-git3, e1000e and e1000 issues
Submitter	: Doug Bazarnic <doug@bazarnic.net>
Date		: 2009-01-09 21:26 (72 days old)
References	: http://marc.info/?l=linux-kernel&m=123153653120204&w=4


