Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZBDNas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZBDNas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZBDNZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:25:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbZBDNZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:25:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       "Arjan Opmeer" <arjan@opmeer.net>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
In-Reply-To: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CGyEB0S4BpO.A.ULC.w5YiJB@chimera>
Subject: [Bug #12406] 2.6.28 thinks that my PS/2 mouse is a touchpad
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:58:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12406
Subject		: 2.6.28 thinks that my PS/2 mouse is a touchpad
Submitter	: Alexander E. Patrakov <patrakov@gmail.com>
Date		: 2008-12-27 9:06 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=123036893817280&w=4
Handled-By	: Arjan Opmeer <arjan@opmeer.net>
Patch		: http://marc.info/?l=linux-kernel&m=123092147703236&w=4


