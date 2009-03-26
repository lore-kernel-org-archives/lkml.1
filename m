Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbZCZQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbZCZQkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZCZQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:40:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44913 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbZCZQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:40:23 -0400
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "david@lang.hm" <david@lang.hm>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0903260008050.13440@asgard.lang.hm>
References: <1237281581.7907.2.camel@ht.satnam>
	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>
	 <49BFC6CB.9070603@zytor.com>
	 <1237958994.5556.5.camel@localhost.localdomain>
	 <20090325125955.GB516@elte.hu>  <1237999971.32497.12.camel@alok-dev1>
	 <1238000840.2500.49.camel@ht.satnam>  <1238001853.32497.22.camel@alok-dev1>
	 <1238002693.2500.52.camel@ht.satnam> <1238005127.32497.38.camel@alok-dev1>
	 <alpine.DEB.1.10.0903260008050.13440@asgard.lang.hm>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 26 Mar 2009 09:40:21 -0700
Message-Id: <1238085621.21971.3.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 00:10 -0700, david@lang.hm wrote:
> On Wed, 25 Mar 2009, Alok Kataria wrote:
> 
> > On Wed, 2009-03-25 at 10:38 -0700, Jaswinder Singh Rajput wrote:
> >> I am not saying we should not hide this behind a config at all. The
> >> point is there is nothing that we save by adding a new config, so what's
> >> the point at all. If you can give me a solid reason like, say, you save
> >> 1% code space with this config option, or 'n' sec in the boottime,  I am
> >> all ears for such an argument.
> >>
> >>
> >
> > So, if there are any tangible benefits with doing this I am ok with it,
> > but your current argument about "Freedom to user"  doesn't sound too
> > compelling.
> 
> isn't it the other way around? you are adding this in, it should be up to 
> you to show that it
> 
> A. has no impact
> 
> B. has a small enough impact that it's not worth the config option

This is what exactly I have mentioned in a mail earlier in this thread.
http://lkml.org/lkml/2009/3/25/333

Alok

