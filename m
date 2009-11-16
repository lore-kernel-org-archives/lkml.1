Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZKPW4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZKPW4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZKPW4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:56:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60293 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbZKPWy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:28 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Soeren Sonnenburg" <sonne@debian.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.fpF.zSdALB@chimera>
Subject: [Bug #14626] oops on boot starting udev
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
Subject		: oops on boot starting udev
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2009-11-14 10:16 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4


