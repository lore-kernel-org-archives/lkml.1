Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZKUPTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZKUPTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZKUPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:19:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbZKUPTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:19:03 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <dave.mueller@gmx.ch>, "Eric Pielbug" <e.a.b.piel@tudelft.nl>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
In-Reply-To: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mYW9sxtWd2G.A.vUF.TDACLB@chimera>
Subject: [Bug #14340] speedstep-ich driver not working in 2.6.31
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 16:02:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14340
Subject		: speedstep-ich driver not working in 2.6.31
Submitter	:  <dave.mueller@gmx.ch>
Date		: 2009-10-07 08:16 (46 days old)
Handled-By	: Eric Pielbug <e.a.b.piel@tudelft.nl>
		  Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://patchwork.kernel.org/patch/54672/
		  http://patchwork.kernel.org/patch/54671/


