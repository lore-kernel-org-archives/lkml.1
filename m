Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYENWep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYENWep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYENWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:34:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48835 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302AbYENWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:34:35 -0400
Date: Wed, 14 May 2008 15:34:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080514220058.GG9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805141533430.20440@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
 <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com>
 <20080514212130.GD9921@parisc-linux.org> <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
 <20080514214326.GF9921@parisc-linux.org> <Pine.LNX.4.64.0805141444220.19897@schroedinger.engr.sgi.com>
 <20080514220058.GG9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matthew Wilcox wrote:

> Since there's no way we've found to date to get the TPC test to you,
> how about we settle for analysing _this_ testcase which did show a
> significant performance degradation for slub?

Could I get the latest version of the test? Or was the March 31st version 
the latest? No later changes?

