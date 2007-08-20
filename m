Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbXHTHn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbXHTHn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXHTHnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:43:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52623 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXHTHnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:43:18 -0400
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <1187595513.6114.176.camel@twins>
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.603735000@chello.nl>  <1187595513.6114.176.camel@twins>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 09:43:13 +0200
Message-Id: <1187595793.6114.177.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 09:38 +0200, Peter Zijlstra wrote:
> Ok, so I got rid of the global stuff, this also obsoletes 3/10.
 
2/10 that is

