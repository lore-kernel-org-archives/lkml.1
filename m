Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbYEORuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbYEORuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762111AbYEORt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:49:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34519 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761516AbYEORtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:49:55 -0400
Date: Thu, 15 May 2008 11:49:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080515174953.GN9921@parisc-linux.org>
References: <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:05:35AM -0700, Christoph Lameter wrote:
> Thanks for using the slab statistics. I wish I had these numbers for the 
> TPC benchmark. That would allow us to understand what is going on while it 
> is running.

Hang on, you want slab statistics for the TPC run?  You didn't tell me
that.  We're trying to gather oprofile data (and having trouble because
the machine crashes when we start using oprofile -- this is with the git
tree you/pekka put together for us to test).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
