Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZF3O2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZF3O2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZF3O2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:28:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40695 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZF3O2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:28:40 -0400
Date: Tue, 30 Jun 2009 15:28:32 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>, martin.petersen@oracle.com,
       Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Yi Yang <yi.y.yang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>
Subject: [git pull] device-mapper important fixes for 2.6.31-rc2
Message-ID: <20090630142832.GI5744@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>, martin.petersen@oracle.com,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Yi Yang <yi.y.yang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following important device-mapper fixes for 2.6.31-rc2:

Mike Snitzer (1):
      dm table: fix blk_stack_limits arg to use bytes not sectors

Milan Broz (1):
      dm exception store: really fix type lookup

 drivers/md/dm-exception-store.c |    9 ++++++---
 drivers/md/dm-table.c           |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)
 
Alasdair
-- 
agk@redhat.com
