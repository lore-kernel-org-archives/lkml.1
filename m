Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZJZTjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZJZTjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZJZTjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:39:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZJZTjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:39:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Paris" <eparis@parisplace.org>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
In-Reply-To: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vX3ILojF2dJ.A.GQ.Bgf5KB@chimera>
Subject: [Bug #14058] Oops in fsnotify
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 20:31:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (68 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


