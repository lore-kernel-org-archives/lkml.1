Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0BAAgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:36:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0BAAgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:36:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Borislav Petkov" <petkovbb@googlemail.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
In-Reply-To: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <d3IDKWHT5gE.A.DLD.q8hZLB@chimera>
Subject: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:22:08 +0100 (CET)
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
Date		: 2009-12-26 9:45 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


