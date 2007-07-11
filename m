Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXGKVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXGKVxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbXGKVx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:53:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:32897 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbXGKVx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:53:27 -0400
Date: Wed, 11 Jul 2007 14:52:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711215219.GY4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <1184190401.12353.152.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184190401.12353.152.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> > If that isn't possible it needs very careful review which just hasn't
> > happened yet. But I'm not convinced even step by step is not possible
> > here.
> 
> There is no step by step thing. You convert an arch to clock events or
> you convert it not.

Indeed, about the only thing can be done is to take a slower approach
to converging the arch specific implementations (hpet, pit, etc).

thanks,
-chris
