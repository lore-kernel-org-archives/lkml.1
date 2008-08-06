Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYHFPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYHFPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYHFPW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:22:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYHFPW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:22:58 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
	a	linuxinterfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: tvrtko.ursulin@sophos.com, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080806151703.GB13996@kroah.com>
References: <20080805202621.GA27489@kroah.com>
	 <20080806100638.9FD672FE8E3@pmx1.sophos.com>
	 <20080806151703.GB13996@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 11:22:49 -0400
Message-Id: <1218036169.27684.244.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 08:17 -0700, Greg KH wrote:
> On Wed, Aug 06, 2008 at 11:05:43AM +0100, tvrtko.ursulin@sophos.com wrote:
> > Greg KH wrote on 05/08/2008 21:26:21:
> > 
> > > > [JON PRESS]  I wouldn't call it lazy, actually.  It's more like
> > > > "economical" or "ergonomic" -- or, dare I say it -- "user-friendly." 
> > In
> > > > this case, the users are the AV vendors who will have to write to the
> > > > API that will come out of this spec.  We will be more inclined to
> > > > appreciate the SDK (for want of a better term) if it covers all the
> > > > bases, rather than force us to go elsewhere for some of our
> > > > requirements.  When we write SDKs, we try to make sure that our users
> > > > will find whatever they need.
> > > 
> > > But realize that you are adding an overhead on us, the kernel community,
> > > to make your life easier.  We are the ones that are taking our time to
> > > review and comment on this code.  We are the ones who will have to live
> > > with this code for forever, and maintain it over the lifetime of linux.
> > > So far, you all have shown no willingness to give anything back to us at
> > > all.
> > 
> > We all? How is that true? I for example wrote some code and am willing to 
> > help maintain it if it gets accepted.
> 
> You did?  I didn't see any patches from you here, did I just happen to
> miss them?
> 
> If Eric's code was based on yours, that's great, but it didn't imply
> maintenance, especially as it doesn't look like your original patches
> much :)

First copyrights in all those files are Sophos.  Tvrtko is where the
basis for most of these code came from.  Although ongoing maintenance
has not been discussed, he and Sophos deffinitely get the credit for
working on code.

-Eric

