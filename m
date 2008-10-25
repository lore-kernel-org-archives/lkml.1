Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYJYWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYJYWB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYJYV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:58:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYJYV6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:58:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>,
       "reinette chatre" <reinette.chatre@intel.com>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
In-Reply-To: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t1C3RWL0r7M.A.wgC.vV5AJB@chimera>
Subject: [Bug #11834] iwl3945: if I leave my machine running overnight, wifi will not work in the morning
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 22:06:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11834
Subject		: iwl3945: if I leave my machine running overnight, wifi will not work in the morning
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-10-19 21:40 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122445440206101&w=4
Handled-By	: reinette chatre <reinette.chatre@intel.com>


