Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbZBHWAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbZBHWAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZBHVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZBHVtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.ueE.U20jJB@chimera>
Subject: [Bug #12661] commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12661
Subject		: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-02-05 14:41 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=64ff3b938ec6782e6585a83d5459b98b0c3f6eb8
References	: http://marc.info/?l=linux-kernel&m=123384496107361&w=4
Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>


