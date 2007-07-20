Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXGTDXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXGTDXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXGTDXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:23:47 -0400
Received: from ozlabs.org ([203.10.76.45]:55897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbXGTDXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:23:47 -0400
Subject: Re: asm-offsets
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20070720032236.GB475@flower.upol.cz>
References: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org>
	 <E1IBdoz-0005Ol-6b@flower>
	 <1184895253.10380.227.camel@localhost.localdomain>
	 <20070720032236.GB475@flower.upol.cz>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 13:23:40 +1000
Message-Id: <1184901820.10380.254.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 05:22 +0200, Oleg Verych wrote:
> On Fri, Jul 20, 2007 at 11:34:13AM +1000, Rusty Russell wrote:
> > On Thu, 2007-07-19 at 23:46 +0200, Oleg Verych wrote:
> > > > This is the structure offsets required by lg.ko's switcher.S.
> > > >
> > > > Unfortunately we don't have infrastructure for private asm-offsets
> > > > creation.
> > > 
> > > I did asm-offsets build rewrite RFC caled asm-values more than four week
> > > ago: <http://mid.gmane.org/20070612234558.648949000@flower.upol.cz>
> > 
> > Indeed, but you're poking the wrong person.  Sam needs to ack or fwd...
> 
> Even busy people can say something about proposed design of that
> rewrite, so work will not stall like this. But lost message is another
> case of course.

Hi Oleg,

	I appreciate your frustration!  Unfortunately I'm not fluent enough in
kbuild to be able to give meaningful commentary, so pinging Sam is my
way of helping this along...

Thanks!
Rusty.



