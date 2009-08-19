Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZHSXpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZHSXpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZHSXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:45:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZHSXiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:38:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "" <unggnu@googlemail.com>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
In-Reply-To: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Era7U-todKF.A._iD.0nIjKB@chimera>
Subject: [Bug #13351] 2.6.30 - 2.6.31 corrupts my system after suspend resume with readonly mounted hard disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:40:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13351
Subject		: 2.6.30 - 2.6.31 corrupts my system after suspend resume with readonly mounted hard disk
Submitter	:  <unggnu@googlemail.com>
Date		: 2009-05-20 14:09 (92 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Handled-By	: Yinghai Lu <yinghai@kernel.org>


