Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYLPToQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYLPToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYLPTnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:43:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYLPTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:43:49 -0500
Date: Tue, 16 Dec 2008 11:43:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Cc: jT <toyj@union.edu>
Subject: mmotm git repository
Message-Id: <20081216114343.2ca29bdf.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"mmotm" is the "-mm tree of the moment" tree.  The -mm patch pile, updated
usually more than once per day.

Thus far the mmotm tree has been available in `quilt' form, at
http://userweb.kernel.org/~akpm/mmotm/.

Each time the mmotm tree is re-uploaded an announcement is sent to the
mm-commits@vger.kernel.org list.  (echo subscribe mm-commits | mail
majordomo@vger.kernel.org).


jT <toyj@union.edu> has developed scripts to pull the mmotm tree down
into a git tree (thanks!), available via

	git clone git://git.zen-sources.org/zen/mmotm.git

browseable here:

	http://git.zen-sources.org/?p=mmotm.git;a=summary

The patch titles are all screwed up - that's my fault, because the
.patch files don't include the title - I'll fix that sometime. 


This is all very new and I don't know what the update latency is.
