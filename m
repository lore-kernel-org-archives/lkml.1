Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYKVWdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYKVWdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbYKVW3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbYKVW3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bernd Schubert" <bs@q-leap.de>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.ibC.m7HKJB@chimera>
Subject: [Bug #12020] scsi_times_out NULL pointer dereference
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12020
Subject		: scsi_times_out NULL pointer dereference
Submitter	: Bernd Schubert <bs@q-leap.de>
Date		: 2008-11-13 10:30 (10 days old)
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=12020#c4


