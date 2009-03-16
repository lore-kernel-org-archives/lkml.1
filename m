Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZCPRYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZCPRYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZCPRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:24:40 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:59493 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCPRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:24:40 -0400
Date: Mon, 16 Mar 2009 12:09:20 -0400 (EDT)
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
Subject: Re: [PATCH 21/35] Do not check for compound pages during the page
 allocator sanity checks
In-Reply-To: <1237196790-7268-22-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161209060.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-22-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

