Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYDIITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYDIITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYDIITp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:19:45 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1735 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYDIITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:19:44 -0400
Date: Wed, 9 Apr 2008 09:19:53 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409081943.GI17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej9gp6ol.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 08:01:14PM +0200, Andi Kleen wrote:
> Andy Whitcroft <apw@shadowen.org> writes:
> >
> > To justify changing checkpatch to loosen its checks I would hope to see
> > an agreed to change to the CodingStyle detailing actually what is now
> > acceptable.  
> 
> Here was a concrete proposal (with patch for CodingStyle) from my side some 
> time ago:
> 
> http://article.gmane.org/gmane.linux.kernel/644306

Yeah, that was a good example of how to go about changinging things.  As
I said on that thread I would happily change checkpatch to follow suit.
Oddly for a CodingStyle discussion there was very "discussion" at all.
It feels like people are scared of the passion that often errupts in
discussions over style.

On that particular suggestion, I would probabally be in favour, and
slightly happier to have the string on the printk line for consistency
even though that would violate the "don't hide information" rule.

-apw
