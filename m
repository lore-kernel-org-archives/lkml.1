Return-Path: <linux-kernel-owner+w=401wt.eu-S932065Ab0AJXF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0AJXF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080Ab0AJXFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:05:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0AJXFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:05:50 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.NgB.qglSLB@chimera>
Subject: [Bug #14939] drm: random hang with i915
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14939
Subject		: drm: random hang with i915
Submitter	: Arnd Bergmann <arnd@arndb.de>
Date		: 2009-12-07 17:30 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=126020704125723&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


