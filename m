Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZEROqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZEROqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZEROqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:46:24 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56578 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754482AbZEROqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:46:23 -0400
Date: Mon, 18 May 2009 10:46:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class
 citizen
In-Reply-To: <20090516092858.GA12104@localhost>
Message-ID: <alpine.DEB.1.10.0905181045340.20244@qirst.com>
References: <20090516090005.916779788@intel.com> <20090516090448.410032840@intel.com> <20090516092858.GA12104@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009, Wu Fengguang wrote:

> vmscan: make mapped executable pages the first class citizen

Nice description! Can you also add the results of a test that shows the
benefit of this patch?

