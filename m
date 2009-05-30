Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbZE3XAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbZE3XAH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761165AbZE3WzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:55:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46837 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761074AbZE3Wy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Samad" <alex@samad.com.au>, "Dave Chinner" <david@fromorbit.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A._pF.ZVbIKB@chimera>
Subject: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Submitter	: Alex Samad <alex@samad.com.au>
Date		: 2009-05-20 0:37 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4


