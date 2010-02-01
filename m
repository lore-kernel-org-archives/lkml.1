Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0BAAhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:37:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0BAAhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:37:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Zhavnerchik" <alex.vizor@gmail.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
In-Reply-To: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <d3IDKWHT5gE.A.ifC.v7hZLB@chimera>
Subject: [Bug #15119] iwl_bg_scan_completed: WARN on scan complete
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:22:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15119
Subject		: iwl_bg_scan_completed: WARN on scan complete
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2010-01-24 12:27 (8 days old)


