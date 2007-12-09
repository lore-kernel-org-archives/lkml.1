Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbXLIEBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbXLIEBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 23:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLIEB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 23:01:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbXLIEBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 23:01:25 -0500
Date: Sat, 8 Dec 2007 20:00:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@thunk.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] random: step more rapidly through the pool when
 adding and extracting
Message-Id: <20071208200055.00762c19.akpm@linux-foundation.org>
In-Reply-To: <20071209014820.GV17037@thunk.org>
References: <2.753618428@selenic.com>
	<6.753618428@selenic.com>
	<20071209014820.GV17037@thunk.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 20:48:20 -0500 Theodore Tso <tytso@thunk.org> wrote:

> On Sat, Dec 08, 2007 at 05:20:39PM -0600, Matt Mackall wrote:
> > random: step more rapidly through the pool when adding and extracting
> > 
> > Second, this patch spreads the mixing across the pool more rapidly by
> > using a larger step. For our secondary pools, we'll be sure to touch
> > both blocks with each mix, and for our primary pool, we'll change 5 of
> > 8 blocks.
> 
> Yeah, that's a good idea.
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 

I cannot find the emails to which you are replying.  Not in inbox, not on
lkml, not in spam folders.  And lkml.org records your emails and not the
emails to which you are replying.

I think something went wrong with Matt's outgoing.
