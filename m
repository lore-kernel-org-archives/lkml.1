Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZJAWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZJAWvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZJAWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:51:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57202 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZJAWuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:50:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Pavel Machek" <pavel@ucw.cz>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q3xT3CnoTGE.A.esG.J4SxKB@chimera>
Subject: [Bug #14296] spitz boots but suspend/resume is broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:38:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
Subject		: spitz boots but suspend/resume is broken
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 12:06 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4


