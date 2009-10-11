Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZJKXFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZJKXFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZJKXFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:05:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZJKXFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:05:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>, "Frans Pop" <elendil@planet.nl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.d4D.P0l0KB@chimera>
Subject: [Bug #14141] order 2 page allocation failures in iwlagn
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
Subject		: order 2 page allocation failures in iwlagn
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-09-06 7:40 (36 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ff05b2b4eac2e63d345fc731ea151a060247f53
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
		  http://lkml.org/lkml/2009/10/2/86
		  http://lkml.org/lkml/2009/10/5/24
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


