Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZJAWiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZJAWiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZJAWiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:38:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZJAWiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:38:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Plamen Petrov" <pvp-lsts@fs.ru.acad.bg>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q3xT3CnoTGE.A.QTH.f4SxKB@chimera>
Subject: [Bug #14214] BUG at drivers/scsi/scsi_lib.c:1108!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:27:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14214
Subject		: BUG at drivers/scsi/scsi_lib.c:1108!
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2009-09-23 11:13 (9 days old)


