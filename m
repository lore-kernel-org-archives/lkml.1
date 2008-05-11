Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYEKVLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYEKVLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbYEKVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370AbYEKVBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:44 -0400
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Jan Engelhardt" <jengelh@medozas.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.GwG.uv1JIB@chimera>
Subject: [Bug #10650] 2.6.26-rcX VC console scrolling regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10650
Subject		: 2.6.26-rcX VC console scrolling regression
Submitter	: David Miller <davem@davemloft.net>
Date		: 2008-05-07 21:46 (5 days old)
References	: http://lkml.org/lkml/2008/5/8/9
Handled-By	: Jan Engelhardt <jengelh@medozas.de>


