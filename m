Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXJ0Ni5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXJ0Ni5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXJ0Niu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:38:50 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:48434 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbXJ0Nit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:38:49 -0400
Subject: Re: [PATCH] voyager: fix breakage caused by boot_params problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071026182609.ea703328.randy.dunlap@oracle.com>
References: <1193419828.3293.35.camel@localhost.localdomain>
	 <20071026182609.ea703328.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 08:38:45 -0500
Message-Id: <1193492325.15612.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 18:26 -0700, Randy Dunlap wrote:
> On Fri, 26 Oct 2007 12:30:28 -0500 James Bottomley wrote:
> 
> > There was a missed conversion in the voyager architecture setup file
> > which this corrects.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> Oh.
> http://lkml.org/lkml/2007/10/22/180
> even cc-ed to you.

Gosh, sorry about that.

I actually marked it to be added too.  Unfortunately, my usual MO is to
get voyager working with the first -rc and then see what the other
updates were ... in this case, I duplicated what you'd already done.

James


