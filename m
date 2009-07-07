Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZGGAId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZGGAId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbZGGAHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:07:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZGGAHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:07:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Vetter" <daniel@ffwll.ch>, "Len Brown" <len.brown@intel.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.-KB.LCpUKB@chimera>
Subject: [Bug #13277] 2.6.30 regression - hang on 2nd resume - bisected - Thinkpad X40
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13277
Subject		: 2.6.30 regression - hang on 2nd resume - bisected - Thinkpad X40
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2009-05-11 10:08 (57 days old)
Handled-By	: Len Brown <len.brown@intel.com>


