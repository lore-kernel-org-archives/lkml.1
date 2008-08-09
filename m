Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYHJAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYHJAOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYHJAKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbYHJAKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.QbB.WDjnIB@albercik>
Subject: [Bug #11254] KVM: fix userspace ABI breakage
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11254
Subject		: KVM: fix userspace ABI breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 21 Jul 2008 17:58:26 (0 days old)
References	: http://lkml.org/lkml/2008/7/21/197
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/7/21/197


