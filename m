Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0BGWus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:50:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab0BGWpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:45:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.khC.KqzbLB@chimera>
Subject: [Bug #14937] WARNING: at kernel/lockdep.c:2830
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


