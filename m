Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbZEXWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbZEXWJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbZEXWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:08:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722AbZEXWIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:08:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Bennee" <kernel-hacker@bennee.com>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.8iB.a-bGKB@chimera>
Subject: [Bug #13171] 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13171
Subject		: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
Submitter	: Alex Bennee <kernel-hacker@bennee.com>
Date		: 2009-04-19 6:27 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=124022460014812&w=4
		  https://bugs.freedesktop.org/show_bug.cgi?id=21480


