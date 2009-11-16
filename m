Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZKPXQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZKPXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZKPXQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:16:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZKPXQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "Chris Wright" <chrisw@sous-sol.org>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.nKC.sndALB@chimera>
Subject: [Bug #14385] DMAR regression in 2.6.31 leads to ext4 corruption?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14385
Subject		: DMAR regression in 2.6.31 leads to ext4 corruption?
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2009-10-08 23:56 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=125504643703877&w=4


