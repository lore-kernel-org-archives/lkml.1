Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0BUWLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:11:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0BUWFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:05:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "okias" <d.okias@gmail.com>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
In-Reply-To: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wj3ZQZlk_KB.A.AXC.3tagLB@chimera>
Subject: [Bug #14817] When is system under load, then freeze/HD fail
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:42:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14817
Subject		: When is system under load, then freeze/HD fail
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-12-15 11:12 (69 days old)


