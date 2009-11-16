Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZKPXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZKPXQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZKPXQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:16:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZKPXQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <jiri.harcarik@gmail.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.rED.rodALB@chimera>
Subject: [Bug #14157] end_request: I/O error, dev cciss/cXdX, sector 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14157
Subject		: end_request: I/O error, dev cciss/cXdX, sector 0
Submitter	:  <jiri.harcarik@gmail.com>
Date		: 2009-09-11 07:42 (67 days old)


