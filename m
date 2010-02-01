Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0BAAiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:38:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0BAAh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:37:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heinz Diehl" <htd@fancy-poultry.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
In-Reply-To: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
Subject: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:22:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15196
Subject		: kmem_cache_create: duplicate cache ccid2_h
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-01-30 18:33 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=126487640324942&w=4


