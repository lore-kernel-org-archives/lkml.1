Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbXJaWCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbXJaWCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760311AbXJaWAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:00:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761AbXJaWAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:00:36 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com
Subject: [PATCH 0/7] (Re-)introducing pvops for x86_64 - Real pvops work part
Date: Wed, 31 Oct 2007 16:14:45 -0300
Message-Id: <1193858101367-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hey folks,

This is the part-of-pvops-implementation-that-is-not-exactly-a-merge. Neat,
uh? This is the majority of the work.

The first patch in the series does not really belong here. It was already
sent to lkml separetedly before, but I'm including it again, for a very
simple reason: Try to test the paravirt patches without it, and you'll fail
miserably ;-) (and it was not yet included).

Other than that, I thank you all in advance for the review.

Have fun!

