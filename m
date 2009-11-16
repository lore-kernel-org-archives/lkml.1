Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZKPWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZKPWry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZKPWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:47:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZKPWrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:47:52 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.0PB.2UdALB@chimera>
Subject: [Bug #14277] Caught 8-bit read from freed memory in b43 driver at association
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:33:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
Subject		: Caught 8-bit read from freed memory in b43 driver at association
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:06 (48 days old)


