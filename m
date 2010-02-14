Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0BNX5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:57:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0BNX5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:57:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
In-Reply-To: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4un6Gst5rKB.A.A7.zkIeLB@chimera>
Subject: [Bug #14937] WARNING: at kernel/lockdep.c:2830
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:38:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


