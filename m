Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYJYXER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYJYXER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYJYXAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:00:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYJYXAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:00:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
In-Reply-To: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gLTYxg3cC1.A.dwF.0K6AJB@chimera>
Subject: [Bug #11512] sort-of regression due to "kconfig: speed up all*config + randconfig"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 23:07:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11512
Subject		: sort-of regression due to "kconfig: speed up all*config + randconfig"
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-09-05 22:50 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=122065498013858&w=4


