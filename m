Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZKPWxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZKPWxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZKPWx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:53:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbZKPWx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
       "john stultz" <johnstul@us.ibm.com>, "Thibault Mondary" <thibm@free.fr>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.8lH.mTdALB@chimera>
Subject: [Bug #14426] CE: hpet increasing min_delta_ns flood
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (31 days old)


