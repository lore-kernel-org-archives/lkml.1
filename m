Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZF2Ait@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZF2Ait (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbZF2Afv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:35:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbZF2Afs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:35:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Harald Dunkel" <harald.dunkel@t-online.de>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A._qG.VkASKB@chimera>
Subject: [Bug #13374] reiserfs blocked for more than 120secs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:30:55 +0200 (CEST)
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
Date		: 2009-05-23 8:52 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=124306880410811&w=4
		  http://lkml.org/lkml/2009/5/29/389


