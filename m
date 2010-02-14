Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0BNX5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:57:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0BNX5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:57:14 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Borislav Petkov" <petkovbb@googlemail.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.P1.pkIeLB@chimera>
Subject: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:38:29 +0100 (CET)
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
Date		: 2009-12-26 9:45 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


