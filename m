Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYHGSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYHGSLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYHGSLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:11:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:45245 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYHGSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lNUbpqzyUrKJLqMTwCkQuKFEkTUrvxn9xev/Bxt0Gsz5IBYYhy5Iw7xinAUY8btNGb
         P9NputAl4SLDZfEhOFRk3di+kAFY30284vs7K0QTfHEPVZN+RrwBZwbKsm0xarmIQR+B
         65cjaB4xdAj+iX35p8o+yWo690V6BByHP18GA=
Date: Thu, 7 Aug 2008 14:11:09 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, bzolnier@gmail.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080807140357.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <20080731194207.GA12233@anvil.corenet.prv> <20080731131056.eecc4826.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731131056.eecc4826.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:10:56PM -0700, Andrew Morton wrote:
> 
> If that works then great.  But I think the printk could be improved. 
> Please provide sufficient information so that users (not programmers)
> can go off and fix things up without needing to email kernel developers.
> 
> One suitable approach would be
> 
> 	printk("see http://userweb.kernel.org/~dtor/read-this.txt")
> 

Ok, I made a small page here:

	http://userweb.kernel.org/~dtor/eviocgbit-bug.html

If you think this is sufficient I'd like to put the patch with the
warning in 2.6.27 so people and distributions could start updarting
affected programs.

-- 
Dmitry
