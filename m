Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZKPXU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZKPXU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZKPXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:20:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbZKPXQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:16:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>, "Frans Pop" <elendil@planet.nl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWmO9uyC1hM.A.ZRD.uodALB@chimera>
Subject: [Bug #14141] order 2 page allocation failures in iwlagn
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 00:01:16 +0100 (CET)
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
Date		: 2009-09-06 7:40 (72 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ff05b2b4eac2e63d345fc731ea151a060247f53
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
		  http://lkml.org/lkml/2009/10/2/86
		  http://lkml.org/lkml/2009/10/5/24
		  http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/01395.html
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


