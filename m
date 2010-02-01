Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0BAA5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:57:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab0BAA5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:57:20 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
       "john stultz" <johnstul@us.ibm.com>, "Thibault Mondary" <thibm@free.fr>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.OHH.VIiZLB@chimera>
Subject: [Bug #14426] CE: hpet increasing min_delta_ns flood
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (107 days old)


