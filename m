Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZHIXkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZHIXkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZHIXkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:40:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZHIXje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:39:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Mack" <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Roel Kluin" <roel.kluin@gmail.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u1L1PAbl8zG.A.2iC.Wj1fKB@chimera>
Subject: [Bug #13947] Libertas: Association request to the driver failed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 22:44:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13947
Subject		: Libertas: Association request to the driver failed
Submitter	: Daniel Mack <daniel@caiaq.de>
Date		: 2009-08-07 19:11 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
Handled-By	: Roel Kluin <roel.kluin@gmail.com>


