Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXHGIQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXHGIQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXHGIQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:16:07 -0400
Received: from 1wt.eu ([62.212.114.60]:1228 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXHGIQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:16:06 -0400
Date: Tue, 7 Aug 2007 10:12:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Axel Reinhold <axel@freakout.de>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070807081229.GA17889@1wt.eu>
References: <20070806211631.GA14501@1wt.eu> <200708070504.l7754KIr004277@bongo.freakout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708070504.l7754KIr004277@bongo.freakout.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 07:04:20AM +0200, Axel Reinhold wrote:
> According to Willy Tarreau:
> > > >Well, top-level assembly is usually nasty.  Setting the section in the
> > > >assembly statement as you said is probably the only thing you *can* do.
> > > 
> 
> I do not understand the details of the discussion, but isn't the
> fact, that there is more than one way for the compiler to produce
> "correct" code of the nasty statements, also a "timebomb" for
> other projects - especially for Linux 2.6?

no because 2.6 uses quite a different method.

Willy

