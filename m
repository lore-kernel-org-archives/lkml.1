Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYLMTBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYLMTBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 14:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYLMTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 14:01:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYLMTBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 14:01:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <mPGxw39gx6O.A.SY.QRARJB@chimera>
In-Reply-To: <mPGxw39gx6O.A.SY.QRARJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rxtftRqgnaB.A.Q4B.3VARJB@chimera>
Subject: [Bug #11215] INFO: possible recursive locking detected ps2_command
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Dec 2008 17:53:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (136 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4


