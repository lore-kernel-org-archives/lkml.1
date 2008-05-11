Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYEKVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYEKVNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbYEKVBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbYEKVBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:49 -0400
Cc: "Rene Herman" <rene.herman@keyaccess.nl>, "Takashi Iwai" <tiwai@suse.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.VWG.hv1JIB@chimera>
Subject: [Bug #10672] 2.6.26-rc1 regression: ISA DMA broken (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10672
Subject		: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Submitter	: Rene Herman <rene.herman@keyaccess.nl>
Date		: 2008-05-09 1:37 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121029711005560&amp;w=4
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121032355203154&amp;w=4


