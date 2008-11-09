Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYKIVm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYKIVm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbYKIVkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:40:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbYKIVkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:40:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       "rdunlap" <randy.dunlap@oracle.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
In-Reply-To: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4B0Eqx89uNG.A.ozD.vb1FJB@chimera>
Subject: [Bug #11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 20:43:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (81 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


