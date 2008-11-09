Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYKIT4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYKIT4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYKITzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:55:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbYKITzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:55:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>,
       "reinette chatre" <reinette.chatre@intel.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.e_.85zFJB@chimera>
Subject: [Bug #11834] iwl3945: if I leave my machine running overnight, wifi will not work in the morning
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:07 +0100 (CET)
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
Date		: 2008-10-19 21:40 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=122445440206101&w=4
Handled-By	: reinette chatre <reinette.chatre@intel.com>


