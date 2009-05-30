Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZE3Wy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZE3Wy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZE3WxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:53:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbZE3WxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:53:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "=?utf-8?q?Michel=20D=C3=A4nzer?=" <michel@daenzer.net>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.TsH.wXbIKB@chimera>
Subject: [Bug #12765] i915 VT switch with AIGLX causes X lock up
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:33 +0200 (CEST)
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
Date		: 2009-02-21 15:38 (99 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
		  http://lkml.org/lkml/2009/4/27/317
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://patchwork.kernel.org/patch/20197/


