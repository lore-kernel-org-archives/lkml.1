Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZFGM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZFGM5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZFGMyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:54:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58318 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbZFGMyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:54:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Martin Bammer" <mrb74@gmx.at>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.NPH.lZ7KKB@chimera>
Subject: [Bug #13366] About 80% of shutdowns fail (blocking)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13366
Subject		: About 80% of shutdowns fail (blocking)
Submitter	: Martin Bammer <mrb74@gmx.at>
Date		: 2009-05-23 00:58 (16 days old)


