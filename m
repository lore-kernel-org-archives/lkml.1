Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYEYTrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYEYTrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYEYTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:47:38 -0400
Received: from 1wt.eu ([62.212.114.60]:1170 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbYEYTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:47:37 -0400
Date: Sun, 25 May 2008 21:47:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Davi Leal <davi@leals.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: I am a volunteer
Message-ID: <20080525194721.GH6749@1wt.eu>
References: <200805251812.41552.davi@leals.com> <20080525163758.GA1791@cs181133002.pp.htv.fi> <200805252023.22510.davi@leals.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805252023.22510.davi@leals.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 08:23:22PM +0200, Davi Leal wrote:
> Adrian Bunk wrote:
> > The easiest and very valuable task is testing the kernel as described at
> >   http://kernelnewbies.org/KernelTesters
> 
> I am more motivated to do development than testing.

And who do you think will test your dev then ?

Testing very quickly involves development because you will notice bugs
first, then missing chunks of code to handle special conditions, and by
this time you will feel much better with kernel internals and will have
no problem starting on more complex tasks.

Also, we're wondering what motivates newcomers to directly dive into
development instead of testing. Would you please explain a bit about
your motivations ? It would help distribute more interesting work to
newcomers, or maybe assign them more credits if it is what they are
seeking.

Willy

