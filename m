Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZIFVPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZIFVPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbZIFVPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:15:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843AbZIFVPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:15:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pauli" <suokkos@gmail.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
In-Reply-To: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hKF51Pczj6N.A.bS.T4BpKB@chimera>
Subject: [Bug #13564] random general protection fault at boot time caused by khubd.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 20:11:50 +0200 (CEST)
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
Date		: 2009-06-18 12:44 (81 days old)


