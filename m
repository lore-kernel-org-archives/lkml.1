Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZL2Ppo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZL2Ppo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZL2Ppa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:45:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZL2Pcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:32:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.EZE.6xhOLB@chimera>
Subject: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-10-23 16:45 (68 days old)
References	: http://lkml.org/lkml/2009/10/23/252


