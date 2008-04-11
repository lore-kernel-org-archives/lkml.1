Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbYDKPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbYDKPyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbYDKPyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:54:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2520 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760069AbYDKPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:54:16 -0400
Date: Fri, 11 Apr 2008 16:54:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080411155421.GB29759@shadowen.org>
References: <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org> <20080409084606.GD19010@one.firstfloor.org> <20080409131420.GL17915@shadowen.org> <alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr> <20080409135840.GO17915@shadowen.org> <20080409095326.8e306c41.akpm@linux-foundation.org> <20080409200746.GR17915@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409200746.GR17915@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 09:07:55PM +0100, Andy Whitcroft wrote:
> On Wed, Apr 09, 2008 at 09:53:26AM -0700, Andrew Morton wrote:
> > On Wed, 9 Apr 2008 14:58:40 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> > 
> > > The originally suggested layout was:
> > > 
> > > 			printk(
> > > "Oh ....",
> > > 				a, b);
> > 
> > Dunno about others, but when I see that idiom I fall over stunned and 
> > can't get up again.
> 
> That remains me of nethack.  I'll start with the width breaker.

Ok.  I've just pushed out a testing version of checkpatch which is
identicle the 0.18 delta I just pushed to Andrew with the printk width
restriction lifted.  Perhaps those interested might test it to see if it
whines appropriatly:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

I am going to be off next week, but will likely be dipping into email
now and again.

-apw
