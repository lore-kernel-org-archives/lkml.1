Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZHBWDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZHBWDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZHBWDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:03:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbZHBWDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:03:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jerome Glisse" <glisse@freedesktop.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.N5E.xpgdKB@chimera>
Subject: [Bug #13897] PAT wc & vmap mapping count issue
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13897
Subject		: PAT wc & vmap mapping count issue
Submitter	: Jerome Glisse <glisse@freedesktop.org>
Date		: 2009-07-30 13:11 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
References	: http://marc.info/?l=linux-kernel&m=124895237114605&w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://patchwork.kernel.org/patch/38436/


