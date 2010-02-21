Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0BUWER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:04:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab0BUWEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:04:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
       "john stultz" <johnstul@us.ibm.com>, "Thibault Mondary" <thibm@free.fr>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
In-Reply-To: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wj3ZQZlk_KB.A.8dD.FyagLB@chimera>
Subject: [Bug #14426] CE: hpet increasing min_delta_ns flood
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:42:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (128 days old)


