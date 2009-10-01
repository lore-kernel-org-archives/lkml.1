Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZJAXIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZJAXIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZJAXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:08:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZJAXIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:08:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.A5C.VOTxKB@chimera>
Subject: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:55:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


