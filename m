Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0BOAS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:18:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60881 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0BOAMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:12:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rich Ercolani" <rercola@acm.jhu.edu>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera>
In-Reply-To: <fQEllunEdO.A.-LB.HyIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Xv2rBFCTXTH.A.LhD.rzIeLB@chimera>
Subject: [Bug #14868] flood of "don't try to register things with the same name in the same directory." on upgrade to 2.6.32
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:52:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14868
Subject		: flood of "don't try to register things with the same name in the same directory." on upgrade to 2.6.32
Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
Date		: 2009-12-24 02:44 (53 days old)


