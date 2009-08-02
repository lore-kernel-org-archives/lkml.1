Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZHBWJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZHBWJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZHBWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:01:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbZHBWBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:01:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Tomas Janousek" <tomi@nomi.cz>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.1FH.6rgdKB@chimera>
Subject: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13337
Subject		: [post 2.6.29 regression] hang during suspend of b44/b43 modules
Submitter	: Tomas Janousek <tomi@nomi.cz>
Date		: 2009-05-18 10:59 (77 days old)
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
Patch		: http://patchwork.kernel.org/patch/37837/


