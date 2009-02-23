Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZBWOtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZBWOtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZBWOsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:48:42 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55187 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755695AbZBWOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:48:41 -0500
Date: Mon, 23 Feb 2009 09:38:58 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902230934360.7298@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, Mel Gorman wrote:

> I haven't run a page-allocator micro-benchmark to see what sort of figures
> that gives. Christoph, I recall you had some sort of page allocator
> micro-benchmark. Do you want to give it a shot or remind me how to use
> it please?

The page allocator / slab allocator microbenchmarks are in my VM
development git tree. The branch is named tests.

http://git.kernel.org/?p=linux/kernel/git/christoph/vm.git;a=shortlog;h=tests


