Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYJYWEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYJYWEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYJYV7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:59:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYJYV7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:59:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
In-Reply-To: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t1C3RWL0r7M.A.ltB.aV5AJB@chimera>
Subject: [Bug #11851] wmifinfo dockapp takes 100% of cpu
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 22:06:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11851
Subject		: wmifinfo dockapp takes 100% of cpu
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2008-10-25 9:40 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122492763030453&w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>
		  Marcin Slusarz <marcin.slusarz@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122496409612709&w=4


