Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZGGAJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZGGAJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZGGAHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:07:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbZGGAHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:07:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.ZFB.BCpUKB@chimera>
Subject: [Bug #13306] hibernate slow on _second_ run
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:36 +0200 (CEST)
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
Date		: 2009-05-14 09:34 (54 days old)


