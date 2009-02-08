Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZBHV7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZBHV7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZBHVtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbZBHVth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Riesen" <fork0@users.sf.net>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.zuE.a20jJB@chimera>
Subject: [Bug #12656] iwl3945 broken after hibernation: Wait for START_ALIVE timeout after 2000ms.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12656
Subject		: iwl3945 broken after hibernation: Wait for START_ALIVE timeout after 2000ms.
Submitter	: Alex Riesen <fork0@users.sf.net>
Date		: 2009-02-08 01:52 (1 days old)


