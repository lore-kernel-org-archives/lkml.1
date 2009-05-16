Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZEPW7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZEPW7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbZEPW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:59:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZEPW7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:59:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "=?utf-8?q?Michel=20D=C3=A4nzer?=" <michel@daenzer.net>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.iyH.9B0DKB@chimera>
Subject: [Bug #12765] i915 VT switch with AIGLX causes X lock up
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:05:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
Subject		: i915 VT switch with AIGLX causes X lock up
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-21 15:38 (85 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
		  http://lkml.org/lkml/2009/4/27/317
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://patchwork.kernel.org/patch/20197/


