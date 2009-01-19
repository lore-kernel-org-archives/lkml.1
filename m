Return-Path: <linux-kernel-owner+w=401wt.eu-S1763104AbZATATc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763104AbZATATc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763344AbZATAGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:06:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762257AbZATAGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:06:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Kevin Shanahan" <kmshanah@flexo.wumi.org.au>,
       "Kevin Shanahan" <kmshanah@ucwb.org.au>,
       "Mike Galbraith" <efault@gmx.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
Subject: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
Subject		: KVM guests stalling on 2.6.28 (bisected)
Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
Date		: 2009-01-17 03:37 (3 days old)


