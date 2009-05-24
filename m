Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZEXW2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZEXW2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbZEXW1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:27:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759156AbZEXW1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:27:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matt Carlson" <mcarlson@broadcom.com>, "Nikolay" <dobrev666@gmail.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.VAE.SRcGKB@chimera>
Subject: [Bug #12971] "tg3 transmit timed out" when transmitting at high bitrate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:16 +0200 (CEST)
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
Date		: 2009-03-29 18:02 (57 days old)
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


