Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZHYXki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZHYXki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbZHYXkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:40:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbZHYXel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:34:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Mack" <daniel@caiaq.de>, "Dan Williams" <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Roel Kluin" <roel.kluin@gmail.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.x8H.QtGlKB@chimera>
Subject: [Bug #13947] Libertas: Association request to the driver failed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:50 +0200 (CEST)
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
Date		: 2009-08-07 19:11 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
Handled-By	: Roel Kluin <roel.kluin@gmail.com>
		  Dan Williams <dcbw@redhat.com>
Patch		: http://patchwork.kernel.org/patch/43114/


