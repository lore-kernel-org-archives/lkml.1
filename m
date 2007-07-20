Return-Path: <linux-kernel-owner+w=401wt.eu-S939067AbXGTBed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939067AbXGTBed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbXGTBeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:34:23 -0400
Received: from ozlabs.org ([203.10.76.45]:51728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759851AbXGTBeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:34:22 -0400
Subject: Re: - lguest-the-asm-offsets.patch removed from -mm tree
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <E1IBdoz-0005Ol-6b@flower>
References: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org>
	 <E1IBdoz-0005Ol-6b@flower>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:34:13 +1000
Message-Id: <1184895253.10380.227.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 23:46 +0200, Oleg Verych wrote:
> > This is the structure offsets required by lg.ko's switcher.S.
> >
> > Unfortunately we don't have infrastructure for private asm-offsets
> > creation.
> 
> I did asm-offsets build rewrite RFC caled asm-values more than four week
> ago: <http://mid.gmane.org/20070612234558.648949000@flower.upol.cz>

Indeed, but you're poking the wrong person.  Sam needs to ack or fwd...

Thanks,
Rusty.


