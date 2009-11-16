Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZKPXCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZKPXCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZKPXCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:02:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbZKPWwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:52:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Frank Mayhar" <fmayhar@google.com>,
       "Holger Freyther" <zecke@selfish.org>, "Theodore Ts'o" <tytso@mit.edu>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.6w.YUdALB@chimera>
Subject: [Bug #14354] Bad corruption with 2.6.32-rc1 and upwards
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
Subject		: Bad corruption with 2.6.32-rc1 and upwards
Submitter	: Holger Freyther <zecke@selfish.org>
Date		: 2009-10-09 15:42 (39 days old)


