Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZHSXnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZHSXnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZHSXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:43:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZHSXjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:39:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Paul Martin" <pm@debian.org>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
In-Reply-To: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Era7U-todKF.A.muC.lmIjKB@chimera>
Subject: [Bug #13583] pdflush uses 5% CPU on otherwise idle system
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:40:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13583
Subject		: pdflush uses 5% CPU on otherwise idle system
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-06-19 13:33 (62 days old)


