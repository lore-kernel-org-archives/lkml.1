Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZBDNbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZBDNbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBDNZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:25:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZBDNZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:25:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frank Groeneveld" <frankgroeneveld@gmail.com>,
       "Pavel Machek" <pavel@suse.cz>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
In-Reply-To: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CGyEB0S4BpO.A.lBC.u5YiJB@chimera>
Subject: [Bug #12407] Kernel 2.6.28 regression: Hang after hibernate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:58:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12407
Subject		: Kernel 2.6.28 regression: Hang after hibernate
Submitter	: Frank Groeneveld <frankgroeneveld@gmail.com>
Date		: 2008-12-28 20:34 (39 days old)
References	: http://marc.info/?l=linux-kernel&m=123049651906081&w=4


