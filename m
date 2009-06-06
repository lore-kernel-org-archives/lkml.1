Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZFFG23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZFFG23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZFFG2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:28:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbZFFG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:28:21 -0400
Date: Fri, 5 Jun 2009 23:27:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Woody Suwalski <woodys@xandros.com>, jbarnes@virtuousgeek.org,
       eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org, tim.gardner@canonical.com, apw@canonical.com,
       stefan.bader@canonical.com
Subject: Re: Intel 915GM MCHBAR bug
Message-Id: <20090605232711.d8503262.akpm@linux-foundation.org>
In-Reply-To: <4A2A0951.1020608@cs.helsinki.fi>
References: <4A242C81.6020906@cs.helsinki.fi>
	<4A298971.5080006@xandros.com>
	<4A2A0951.1020608@cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Jun 2009 09:14:41 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> >> Wanna show us the patch?
> >>
> >> Because the world could certainly do with more i915 bugfixes :(
> >   
> > Here is Jesse's patch from 
> > http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
> > adopted for 2.6.30-rc8... (needed to redo hunk #3 for i915_gem_tile.c)
> 
> Yup. I took the two patches from here:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314
> 
> and did the same rediffing on top of 2.6.30-rc8 for the first one.
> 
> Andrew, do you want me to forward you the (tested) patches or should we 
> wait for Jesse et al to take care of it?

Yes, please send them out.

These might end up being 2.6.30.1 material.
