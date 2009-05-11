Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbZEKR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbZEKR5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbZEKR41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:56:27 -0400
Received: from kroah.org ([198.145.64.141]:55895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168AbZEKR40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:56:26 -0400
Date: Mon, 11 May 2009 10:47:05 -0700
From: Greg KH <greg@kroah.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511174705.GE4534@kroah.com>
References: <20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de> <20090509223454.4642753d.akpm@linux-foundation.org> <20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> <ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> <20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> <b637ec0b0905110449n15340bbepb3a5adc2cee32b28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0905110449n15340bbepb3a5adc2cee32b28@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 01:49:03PM +0200, Fabio Comolli wrote:
> Hi
> 
> On Mon, May 11, 2009 at 3:22 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> [BIG snip]
> > Devtmpfs is the simplest, is the fastest, is the most reliable, and it
> > is the most flexible option for us. And still, nobody will be forced
> > to use it, it's entirely optional. For our systems, we decided to do
> > it that way, and we ship it already in the distro, and if there are no
> > substantial problems coming up, which we don't expect, we will
> > continue using it.
> 
> Can you please point me to a SuSE kernel that ships with this new feature?

It's in the FACTORY tree right now, and will be shown publically in a
few weeks at some trade shows.

thanks,

greg k-h
