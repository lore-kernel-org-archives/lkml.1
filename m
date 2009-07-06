Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGGABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGGABS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZGFX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZGFX5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul Collins" <paul@burly.ondioline.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.UAE.P0oUKB@chimera>
Subject: [Bug #13728] 2.6.31-rc2 soft lockups, RPC-related
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13728
Subject		: 2.6.31-rc2 soft lockups, RPC-related
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-07-05 7:17 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124677884816794&w=4


