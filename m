Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270Ab0AXWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0AXWRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255Ab0AXWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:17:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45507 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0AXWRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:00 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Borislav Petkov" <petkovbb@googlemail.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.NoG.4KMXLB@chimera>
Subject: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


