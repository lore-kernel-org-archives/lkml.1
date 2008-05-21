Return-Path: <linux-kernel-owner+w=401wt.eu-S1764576AbYEUV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764576AbYEUV44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761782AbYEUV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:56:30 -0400
Received: from 1wt.eu ([62.212.114.60]:4752 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762094AbYEUV43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:56:29 -0400
Date: Wed, 21 May 2008 23:56:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       gorcunov@gmail.com, tytso@mit.edu, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: CFD: linux-wanking@vger.kernel.org
Message-ID: <20080521215606.GA32552@1wt.eu>
References: <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <20080521123127.3b3b66af.akpm@linux-foundation.org> <20080521.131046.242739198.davem@davemloft.net> <20080521212547.GB6749@1wt.eu> <483497CA.7080604@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483497CA.7080604@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 11:44:42PM +0200, Stefan Richter wrote:
> Willy Tarreau wrote:
> >If we want to get more manpower on bug hunting, we should really
> >think about what type of work we need, and simply assign credit
> >to people.
> 
> People fix bugs when they realize that nobody else is going to do it for 
> them.

That's partly true. But we don't need people to fix all bugs by themselves,
otherwise we might take more time trying to fix their own fixes. We most of
all need them to *work* on bugs, which is not the same. Actively
participating to tests and bug hunting is a very important activity. Let's
get the original code author propose a fix once the bug is pointed to.

Willy

