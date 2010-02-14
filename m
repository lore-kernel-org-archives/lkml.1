Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0BOACr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:02:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0BNX5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:57:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "ykzhao" <yakui.zhao@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.ud.LkIeLB@chimera>
Subject: [Bug #15036] soft lockup in dmesg after suspend/resume
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15036
Subject		: soft lockup in dmesg after suspend/resume
Submitter	: ykzhao <yakui.zhao@intel.com>
Date		: 2010-01-04 5:36 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=126258356202722&w=4


