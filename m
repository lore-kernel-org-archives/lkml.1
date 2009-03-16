Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZCPTdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZCPTdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCPTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:33:37 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:55332 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCPTdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:33:36 -0400
Date: Mon, 16 Mar 2009 15:30:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/27] Break up the allocator entry point into fast and
 slow paths
In-Reply-To: <1237226020-14057-6-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161529550.9745@qirst.com>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie> <1237226020-14057-6-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Looks also like a good cleanup of the page allocator.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

