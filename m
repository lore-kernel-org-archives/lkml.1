Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZHBWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZHBWJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZHBWJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:09:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZHBWA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:00:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.BmH.VsgdKB@chimera>
Subject: [Bug #13306] hibernate slow on _second_ run
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
Subject		: hibernate slow on _second_ run
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2009-05-14 09:34 (81 days old)


