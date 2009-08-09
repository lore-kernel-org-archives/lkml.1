Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZHJAEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZHJAEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZHJAEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:04:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbZHJAEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:04:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alejandro Riveira" <ariveira@gmail.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
In-Reply-To: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRuaDVjxFBG.A.4GG.wF2fKB@chimera>
Subject: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 23:10:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
Subject		: rt2x00: slow wifi with correct basic rate bitmap
Submitter	: Alejandro Riveira <ariveira@gmail.com>
Date		: 2009-05-22 13:32 (80 days old)


