Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZFGNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZFGNAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbZFGMzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZFGMzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Pascal Terjan" <pterjan@mandriva.com>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.fRG._Y7KKB@chimera>
Subject: [Bug #13470] Machine doesn't boot due to mmconfig detection problem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13470
Subject		: Machine doesn't boot due to mmconfig detection problem
Submitter	: Pascal Terjan <pterjan@mandriva.com>
Date		: 2009-05-29 19:35 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=044cd80942e47b9de0915b627902adf05c52377f
References	: http://marc.info/?l=linux-kernel&m=124388792118481&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: http://patchwork.kernel.org/patch/27613/


