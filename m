Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYANWQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYANWQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYANWQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbYANWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:33 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [0/31] Great change_page_attr patch series v2
Date: Mon, 14 Jan 2008 23:16:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lots of improvements to change_page_attr(). Make it a lot more
efficient and fix various bugs.

Changes against earlier version

- Fixed some checkpatch.pl complaints
- Improved self test suite
- Fixed more reference bugs 
- Fix NX handling on 32bit
- Remove some useless code there
- Few other random fixes

-Andi
