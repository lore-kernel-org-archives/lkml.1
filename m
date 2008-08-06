Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbYHFKvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbYHFKvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYHFKvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:51:37 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53503 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYHFKvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:51:35 -0400
Date: Wed, 6 Aug 2008 13:50:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tvrtko.ursulin@sophos.com
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080806105008.GF6477@cs181140183.pp.htv.fi>
References: <20080805202621.GA27489@kroah.com> <20080806100638.9FD672FE8E3@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080806100638.9FD672FE8E3@pmx1.sophos.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:05:43AM +0100, tvrtko.ursulin@sophos.com wrote:
> Greg KH wrote on 05/08/2008 21:26:21:
> 
> > > [JON PRESS]  I wouldn't call it lazy, actually.  It's more like
> > > "economical" or "ergonomic" -- or, dare I say it -- "user-friendly." 
> In
> > > this case, the users are the AV vendors who will have to write to the
> > > API that will come out of this spec.  We will be more inclined to
> > > appreciate the SDK (for want of a better term) if it covers all the
> > > bases, rather than force us to go elsewhere for some of our
> > > requirements.  When we write SDKs, we try to make sure that our users
> > > will find whatever they need.
> > 
> > But realize that you are adding an overhead on us, the kernel community,
> > to make your life easier.  We are the ones that are taking our time to
> > review and comment on this code.  We are the ones who will have to live
> > with this code for forever, and maintain it over the lifetime of linux.
> > So far, you all have shown no willingness to give anything back to us at
> > all.
> 
> We all? How is that true? I for example wrote some code and am willing to 
> help maintain it if it gets accepted. And as you describe it, it would be 
> true for any submission because not all things are usefull for all people, 
> while everything is baggage for the community. And who is the community? I 
> thought all who take place in discussions, bug reporting, submitting code, 
> fixing bugs etc are the community.

As an observer of this thread:

- Some set of requirements suddenly appears out of the void on 
  linux-kernel.
- Noone is able and/or willing to exactly describe the problem(s) they 
  are trying to solve.

With this status quo the discussion is going nowhere - Linux kernel 
development does not work this way.

The aim is not to include this code, but to find the best technical 
solution for your problem(s) - no matter whether this will have anything
in common with the list of requirements and the code posted or not.

> Tvrtko

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

