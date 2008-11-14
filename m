Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYKNBVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYKNBVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYKNBU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:20:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:54745 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKNBUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AKtn8DqAh6O/EJfqtEGFCiYVCDVbydqjFMkBnTKVUdDqVphtXpczcPqMKjJ8APw0im
         xEOEY16V2XzI0hUW7k7VlKT+upyWRLUPVMUnZIoisFZAg23zYA62L/WI9CCPqhS7sFKp
         pCHSVbS6wgBK5xoK0pR7XEGzMuksGTweNMxyw=
Date: Fri, 14 Nov 2008 04:20:50 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Mark Brown <broonie@sirena.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-ID: <20081114012050.GA21272@zarina>
Reply-To: cbouatmailru@gmail.com
References: <1226416083-12875-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112164722.GB3882@sortiz.org> <20081112164900.GJ8767@sirena.org.uk> <20081112165705.GC3882@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20081112165705.GC3882@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:57:06PM +0100, Samuel Ortiz wrote:
> On Wed, Nov 12, 2008 at 04:49:01PM +0000, Mark Brown wrote:
> > On Wed, Nov 12, 2008 at 05:47:23PM +0100, Samuel Ortiz wrote:
> > 
> > > The MFD part looks good to me: 
> > > > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > Acked-by: Samuel Ortiz <sameo@openedhand.com>
> > 
> > I forgot to mention it on the repost (I did on the original) 
> Ah, sorry..
> 
> 
> > that since
> > this depends on the AUXADC support queued in the MFD tree it probably
> > makes sense to merge it via there.  Would you be OK with that if Anton
> > OKs the driver?
> I'll queue it once I get Anton's ACK, no problem.

The patch looks OK.

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
