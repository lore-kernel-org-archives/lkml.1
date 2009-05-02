Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbZEBOSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbZEBOSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZEBORx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:17:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbZEBORw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:17:52 -0400
Message-ID: <49FC5554.2070802@redhat.com>
Date: Sat, 02 May 2009 10:14:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] vmscan: cleanup the scan batching code
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org> <20090501012212.GA5848@localhost> <20090430194907.82b31565.akpm@linux-foundation.org> <20090502023125.GA29674@localhost>
In-Reply-To: <20090502023125.GA29674@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> The vmscan batching logic is twisting. Move it into a standalone
> function nr_scan_try_batch() and document it.  No behavior change.
> 
> CC: Nick Piggin <npiggin@suse.de>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
