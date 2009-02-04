Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZBDNFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZBDNFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZBDMvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:51:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZBDMvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:51:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.xUD.kuYiJB@chimera>
Subject: [Bug #12616] boot hang: async vs. kexec
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12616
Subject		: boot hang: async vs. kexec
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2009-01-29 13:15 (7 days old)
References	: http://lkml.org/lkml/2009/1/29/359


