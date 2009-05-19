Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZEVGEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZEVGEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZEVGEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:04:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVGED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:04:03 -0400
Date: Tue, 19 May 2009 22:30:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: Theodore Tso <tytso@mit.edu>, Joseph Cihula <joseph.cihula@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com, John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090519203051.GB1362@ucw.cz>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So we should expect a certain amount of controversy and people
> > lobbying to resist the acceptance of this patch.
> 
> FWIW, here's my response to an earlier private enquiry from John on the 
> topic:
> 
>   I'd prefer discussion to be public, so I don't mind leaving more 
>   detailed discussion to that.
> 
>   There has been considerable discussion on the issue, following Linus' 
>   statement (which I'm sure you're aware of):
> 
>   http://marc.info/?l=linux-kernel&m=105115686114064&w=2
> 
>   My position is similar -- people can decide for themselves whether they 
>   want to use DRM technology.  

Actually, they can not. Basically, my neighbors decide if I have to
 use the DRM technology. Because as soon as too many of them use it
 ISPs/banks/youtube will just make it mandatory.

I dont't think my neighbors should have that kind of power over me,
and the only way to ensure that seems to be keeping TXT and similar
stuff far away from mainline.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
