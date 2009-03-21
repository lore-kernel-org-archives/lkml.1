Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZCUTZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZCUTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZCUTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:19:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZCUTTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:19:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Raymond Wooninck" <tittiatcoke@gmail.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.4h.uZTxJB@chimera>
Subject: [Bug #12846] Regression issue with kernel 2.6.29-rc6-git1: high power consumption during sleep
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12846
Subject		: Regression issue with kernel 2.6.29-rc6-git1: high power consumption during sleep
Submitter	: Raymond Wooninck <tittiatcoke@gmail.com>
Date		: 2009-03-09 08:18 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1fb25cb8b83e85f5bf1a4adb3c9a254c4ce92405


