Return-Path: <linux-kernel-owner+w=401wt.eu-S970550AbXEHXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970550AbXEHXs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967796AbXEHXsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:48:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:24499 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967567AbXEHXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Q1H534GLpVSeOadS6rDyR8UvCHJdzripZwGgeFZNqYOPG9R76ZWug2WeF2XdE1mhJcQ4/FfBFxptldUYw/abaaqFb45t4OLOD2E663/E16s8xtq15amiL0rm0KwbftEzvw8WNXjg44IxxpKZMZuk9fuLb6xkwbmPQzy9hVvJkF0=
Date: Wed, 9 May 2007 01:47:42 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, ak@suse.de
Subject: Re: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-ID: <20070508234742.GB11683@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070508172233.GA11683@slug> <20070508221229.GB17482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508221229.GB17482@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:12:29AM +0200, Andi Kleen wrote:
> On Tue, May 08, 2007 at 07:22:33PM +0200, Frederik Deweerdt wrote:
> > On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > 
> > Hi all,
> > 
> > My computer fails early at boot with a stack along the lines of:
> 
> Do you have a full oops (.jpg or serial)? 
Yup, I've uploaded the .jpg at http://fdeweerdt.free.fr/kmem_prob/
The faulty address is missing from the shot, but it's %edi+0xc

Thanks,
Frederik
