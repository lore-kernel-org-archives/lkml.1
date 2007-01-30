Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXA3Knl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXA3Knl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbXA3Knl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:43:41 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57820 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160AbXA3Knk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:43:40 -0500
Date: Tue, 30 Jan 2007 13:43:04 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070130104304.GA4024@2ka.mipt.ru>
References: <20070129145227.GA10524@2ka.mipt.ru> <40f323d00701290747y68c8e27ege824694bfa378f58@mail.gmail.com> <20070130011817.GI3541@interface.residence.ens-lyon.fr> <20070130095316.GD2455@2ka.mipt.ru> <20070130102451.GE3466@implementation.labri.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070130102451.GE3466@implementation.labri.fr>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 30 Jan 2007 13:43:09 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 11:24:51AM +0100, Samuel Thibault (samuel.thibault@ens-lyon.org) wrote:
> Evgeniy Polyakov, le Tue 30 Jan 2007 12:53:16 +0300, a écrit :
> > > You may want to have a look at some existing implementations:
> > 
> > I saw most of them.
> > As far as I recall, only PTL (is not shown here) has preemptible
> > scheduler. NTL has it too, but is based on different approach.
> 
> Marcel has a preemptible scheduler too, based on signals and
> setjmp/longjmp.

Do some documentation and benchmarks exist for that library - site seems
to only described environment is was created for? How does blocking
problem solved?

> Samuel

-- 
	Evgeniy Polyakov
