Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYLDAtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYLDAtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbYLDApX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:45:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbYLDApS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:45:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "reinette chatre" <reinette.chatre@intel.com>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
In-Reply-To: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TpbYvO5GPt.A.ksE.RGyNJB@chimera>
Subject: [Bug #11983] iwlagn: wrong command queue 31, command id 0x0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 23:40:31 +0100 (CET)
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
Date		: 2008-11-06 4:16 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=122598672815803&w=4
		  http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703
Handled-By	: reinette chatre <reinette.chatre@intel.com>


