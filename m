Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYKVXB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYKVXB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbYKVXAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:00:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbYKVXAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:00:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "reinette chatre" <reinette.chatre@intel.com>
References: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera>
In-Reply-To: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V2w_GS-X2aE.A.u1G.OwIKJB@chimera>
Subject: [Bug #11983] iwlagn: wrong command queue 31, command id 0x0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:59:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11983
Subject		: iwlagn: wrong command queue 31, command id 0x0
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2008-11-06 4:16 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=122598672815803&w=4
		  http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703
Handled-By	: reinette chatre <reinette.chatre@intel.com>


