Return-Path: <linux-kernel-owner+w=401wt.eu-S1764364AbZATANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764364AbZATANr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbZATAFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:05:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761669AbZATAFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:05:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gergely Imreh" <imrehg@gmail.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.p8C._JRdJB@chimera>
Subject: [Bug #12391] Processor does not go below C2 state until usb.autosuspend is enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12391
Subject		: Processor does not go below C2 state until usb.autosuspend is enabled
Submitter	: Gergely Imreh <imrehg@gmail.com>
Date		: 2009-01-09 02:35 (11 days old)


