Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZBNXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZBNXNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZBNXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:07:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44579 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZBNXHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Damien Wyart" <damien.wyart@free.fr>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera>
Subject: [Bug #12650] Strange load average and ksoftirqd behavior with 2.6.29-rc2-git1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12650
Subject		: Strange load average and ksoftirqd behavior with 2.6.29-rc2-git1
Submitter	: Damien Wyart <damien.wyart@free.fr>
Date		: 2009-01-20 16:25 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=123246937207675&w=2


