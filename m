Return-Path: <linux-kernel-owner+w=401wt.eu-S934890AbXGYSxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890AbXGYSxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764638AbXGYSw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:52:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43009 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762604AbXGYSw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:52:58 -0400
Date: Wed, 25 Jul 2007 20:53:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
Message-ID: <20070725185328.GA28199@uranus.ravnborg.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 08:48:50PM +0200, Michal Piotrowski wrote:
> On 25/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> >
> >
> 
> Andi, this might be interesting for you
> 
> make allmodconfig
> make
> [...]
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> c02041b3 00705601   R_386_32 c0308aa8  _sdata

Who did spit out this warning. Can you please provide make V=1
where we see the lines preceeding the warning.

And config please.

	Sam
