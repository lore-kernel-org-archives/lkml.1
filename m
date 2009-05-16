Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZEPWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZEPWTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbZEPWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:15:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959AbZEPWP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:15:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergei Trofimovich" <slyich@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.j2.vYzDKB@chimera>
Subject: [Bug #13294] i915: drm: xorg leaks drm objects massively
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13294
Subject		: i915: drm: xorg leaks drm objects massively
Submitter	: Sergei Trofimovich <slyich@gmail.com>
Date		: 2009-05-10 19:56 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124198547027903&w=4


