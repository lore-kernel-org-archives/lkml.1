Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZE2Gi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZE2Gi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZE2Gis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:38:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:52911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbZE2Gir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:38:47 -0400
Subject: Re: Xen is a feature
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: jeremy@goop.org, mingo@elte.hu, dan.magenheimer@oracle.com, avi@redhat.com,
       George.Dunlap@eu.citrix.com, xen-devel@lists.xensource.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, keir.fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com, npiggin@suse.de
In-Reply-To: <20090528.210559.137121893.davem@davemloft.net>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	 <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>
	 <20090528.210559.137121893.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 29 May 2009 12:07:32 +0530
Message-Id: <1243579052.3159.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Thu, 2009-05-28 at 21:05 -0700, David Miller wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> Date: Thu, 28 May 2009 17:45:34 -0700
> 
> > Ingo Molnar wrote:
> >> Xen changes - especially dom0 - are overwhelmingly not about improving
> >> Linux, but about having some special hook and extra treatment in
> >> random places - and that's really bad.
> >>   
> > 
> > You've made this argument a few times now, and I take exception to it.
> > 
> > It seems to be predicated on the idea that Xen has some kind of niche
> > usage, with barely more users than Voyager.  Or that it is a parasite
> > sitting on the side of Linux, being a pure drain.
> 
> I don't see Ingo's comments, whether I agree with them or not, as
> an implication of Xen being niche.  Rather I see his comments as
> an opposition to how Xen is implemented.
> 

You can see Ingo's comments and whole thread under subject :

Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)

http://lkml.org/lkml/2009/5/27/758

--
JSR

