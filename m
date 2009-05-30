Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbZE3W4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbZE3W4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbZE3Wx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:53:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670AbZE3Wxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:53:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matt Carlson" <mcarlson@broadcom.com>, "Nikolay" <dobrev666@gmail.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.GOH.mWbIKB@chimera>
Subject: [Bug #12971] "tg3 transmit timed out" when transmitting at high bitrate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12971
Subject		: "tg3 transmit timed out" when transmitting at high bitrate
Submitter	: Nikolay <dobrev666@gmail.com>
Date		: 2009-03-29 18:02 (63 days old)
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


