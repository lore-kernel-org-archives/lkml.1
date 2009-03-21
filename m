Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZCUTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZCUTu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZCUTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:47:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbZCUTrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:47:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Avi Kivity" <avi@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Kevin Shanahan" <kmshanah@flexo.wumi.org.au>,
       "Kevin Shanahan" <kmshanah@ucwb.org.au>,
       "Mike Galbraith" <efault@gmx.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.0nF.v8TxJB@chimera>
Subject: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:27 +0100 (CET)
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
Date		: 2009-01-17 03:37 (64 days old)
References	: http://lkml.org/lkml/2009/3/15/51
Handled-By	: Avi Kivity <avi@redhat.com>


