Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZHSXl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZHSXl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZHSXl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:41:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbZHSXjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:39:46 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Martin Rogge" <marogge@onlinehome.de>, "Mike Travis" <travis@sgi.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
In-Reply-To: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Era7U-todKF.A.CHC.wlIjKB@chimera>
Subject: [Bug #13933] System lockup on dual Pentium-3 with kernel 2.6.30
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:40:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13933
Subject		: System lockup on dual Pentium-3 with kernel 2.6.30
Submitter	: Martin Rogge <marogge@onlinehome.de>
Date		: 2009-08-08 13:16 (12 days old)


