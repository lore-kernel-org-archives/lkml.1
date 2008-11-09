Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYKIUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYKIUD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYKIT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:56:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbYKIT4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:56:38 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Jesper Dangaard Brouer" <hawk@comx.dk>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Robert Richter" <robert.richter@amd.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.AAH.B5zFJB@chimera>
Subject: [Bug #11908] linux-2.6.28-rc2 regression : oprofile doesnt work anymore
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11908
Subject		: linux-2.6.28-rc2 regression : oprofile doesnt work anymore
Submitter	: Eric Dumazet <dada1@cosmosbay.com>
Date		: 2008-10-30 18:01 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c493756e2a8a78bcaae30668317890dcfe86e7c3
References	: http://marc.info/?l=linux-kernel&m=122539004100532&w=4


