Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYJYV7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYJYV7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJYV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:58:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYJYV6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:58:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stefan Richter" <stefan-r-bz@s5r6.in-berlin.de>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
In-Reply-To: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <t1C3RWL0r7M.A.B0C.7V5AJB@chimera>
Subject: [Bug #11824] raw1394: possible deadlock if accessed by multithreaded app
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 22:06:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11824
Subject		: raw1394: possible deadlock if accessed by multithreaded app
Submitter	: Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
Date		: 2008-10-25 02:08 (1 days old)


