Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZGGAQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZGGAQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbZGGAJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:09:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbZGGAJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:09:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pauli" <suokkos@gmail.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
In-Reply-To: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bXZeuxPQAWE.A.FLH.WApUKB@chimera>
Subject: [Bug #13564] random general protection fault at boot time caused by khubd.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 02:00:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13564
Subject		: random general protection fault at boot time caused by khubd.
Submitter	: Pauli <suokkos@gmail.com>
Date		: 2009-06-18 12:44 (19 days old)


