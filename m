Return-Path: <linux-kernel-owner+w=401wt.eu-S938071AbXG3TZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938071AbXG3TZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936388AbXG3TZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:25:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33630 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936279AbXG3TZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:25:28 -0400
Date: Mon, 30 Jul 2007 12:25:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLUB updates
Message-ID: <Pine.LNX.4.64.0707301222120.4252@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull
  
git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git to-linus

Peter Zijlstra (2):
      slub: add lock debugging check
      slub: fix bug in slub debug support

 mm/slub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

