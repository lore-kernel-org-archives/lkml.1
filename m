Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZFSIHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZFSIHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZFSIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:07:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59522 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZFSIHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:07:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090619055848.GA27802@localhost>
References: <20090619055848.GA27802@localhost> <20090517022327.280096109@intel.com> <32411.1245336412@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Wang, Roger" <roger.wang@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class citizen
Date: Fri, 19 Jun 2009 09:06:16 +0100
Message-ID: <4278.1245398776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:

> There are plenty of free pages. Is it a page allocator bug? Is it
> stable v2.6.30 or pre 2.6.31-rc1?

Cutting edge Linus after I pulled his new patches yesterday morning:

	commit 65795efbd380a832ae508b04dba8f8e53f0b84d9

David
