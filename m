Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZHBWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZHBWI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZHBWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:08:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZHBWBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:01:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Harald Dunkel" <harald.dunkel@t-online.de>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.guG.mrgdKB@chimera>
Subject: [Bug #13374] reiserfs blocked for more than 120secs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13374
Subject		: reiserfs blocked for more than 120secs
Submitter	: Harald Dunkel <harald.dunkel@t-online.de>
Date		: 2009-05-23 8:52 (72 days old)
References	: http://marc.info/?l=linux-kernel&m=124306880410811&w=4
		  http://lkml.org/lkml/2009/5/29/389


