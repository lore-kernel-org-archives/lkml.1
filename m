Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZBNXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZBNXIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZBNXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:06:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbZBNXGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:06:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ralf Hildebrandt" <ralf.hildebrandt@charite.de>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.IsF.Ys0lJB@chimera>
Subject: [Bug #12551] end_request: I/O error, dev cciss/c0d0, sector 87435720
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12551
Subject		: end_request: I/O error, dev cciss/c0d0, sector 87435720
Submitter	: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Date		: 2009-01-27 06:51 (19 days old)


