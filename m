Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZCUTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZCUTXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZCUTTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:19:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZCUTSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:18:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.v9.HaTxJB@chimera>
Subject: [Bug #12800] x86 PAT invalid vm_insert_pfn assumptions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12800
Subject		: x86 PAT invalid vm_insert_pfn assumptions
Submitter	: Thomas Hellstrom <thellstrom@vmware.com>
Date		: 2009-03-02 01:40 (20 days old)


