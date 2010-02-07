Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0BGWpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:45:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0BGWp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:45:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Borislav Petkov" <petkovbb@googlemail.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.4bC._pzbLB@chimera>
Subject: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (44 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


