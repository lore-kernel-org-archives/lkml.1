Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZHYXlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZHYXlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbZHYXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:41:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58614 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbZHYXeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:34:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.DM.UtGlKB@chimera>
Subject: [Bug #13942] Troubles with AoE and uninitialized object
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
Subject		: Troubles with AoE and uninitialized object
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-04 10:12 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4


