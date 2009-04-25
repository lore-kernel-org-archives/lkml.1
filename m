Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZDYWZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZDYWZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZDYWUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:20:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbZDYWUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:20:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Bennee" <kernel-hacker@bennee.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.XrC.0c48JB@chimera>
Subject: [Bug #13171] 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:50 +0200 (CEST)
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
Date		: 2009-04-19 6:27 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=124022460014812&w=4


