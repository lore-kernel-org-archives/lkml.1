Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZCUTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZCUTtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZCUTrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:47:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbZCUTrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:47:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Raitz" <pappy_mcfae@yahoo.com>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.ULF.f8TxJB@chimera>
Subject: [Bug #12634] video distortion and lockup with i830 video chip and 2.6.28.3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12634
Subject		: video distortion and lockup with i830 video chip and 2.6.28.3
Submitter	: Bob Raitz <pappy_mcfae@yahoo.com>
Date		: 2009-02-04 21:10 (46 days old)


