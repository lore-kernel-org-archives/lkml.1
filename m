Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZDUPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZDUPRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZDUPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:17:04 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:38638 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZDUPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:17:01 -0400
Date: Tue, 21 Apr 2009 11:08:46 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 24/25] Re-sort GFP flags and fix whitespace alignment
 for easier reading.
In-Reply-To: <20090421085229.GH12713@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904211107250.19969@qirst.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-25-git-send-email-mel@csn.ul.ie> <1240301043.771.56.camel@penberg-laptop> <20090421085229.GH12713@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Mel Gorman wrote:

> Hmm, doh. This resorted when another patch existed that no longer exists
> due to difficulties. This patch only fixes whitespace now but I didn't fix
> the changelog.  I can either move it to the next set altogether where it
> does resort things or drop it on the grounds whitespace patches just muck
> with changelogs. I'm leaning towards the latter.

Where were we with that other patch? I vaguely recalling reworking the
other patch (gfp_zone I believe) to be calculated at compile time. Did I
drop this?

