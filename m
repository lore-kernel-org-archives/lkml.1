Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZBDNZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZBDNZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZBDNY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:24:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbZBDNY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:24:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
In-Reply-To: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CGyEB0S4BpO.A.klD.Z6YiJB@chimera>
Subject: [Bug #12208] uml is very slow on 2.6.28 host
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:58:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
Subject		: uml is very slow on 2.6.28 host
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-12-12 9:35 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4


