Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZCNVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZCNVi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZCNVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:38:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41488 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZCNVi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:38:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.32F.c7BvJB@chimera>
Subject: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:01:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12414
Subject		: iwl4965 cannot use "ap auto" on latest 2.6.28/29?
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-01-05 4:13 (69 days old)
References	: http://marc.info/?l=linux-kernel&m=123112882127823&w=4


