Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbYD3Wlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbYD3Wlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYD3Wlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:41:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYD3Wll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:41:41 -0400
Date: Wed, 30 Apr 2008 15:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430154124.7ec08dd4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302245.50817.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org>
	<200805010023.32213.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:31:22 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Any suggestions on how to convince people that their code is not worth 
> merging?

Raise the quality.  Then the volume will automatically decrease.

Which leads us to...  the volume isn't a problem per-se.  The problem is
quality.  It's the fact that they vary inversely which makes us say "slow
down".

So David's Subject: should have been "Do Better, please".  Slowing down is
just a side-effect.  And, we expect, a tool.


We should be discussing how to raise the quality of our work.
