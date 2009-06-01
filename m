Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZFAL2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZFAL2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZFAL21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:28:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:48294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZFAL20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:28:26 -0400
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch
 warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Airlie <airlied@linux.ie>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jarod Wilson <jarod@redhat.com>, drm list <dri-devel@lists.sf.net>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, mjg@redhat.com
In-Reply-To: <20090601115334.37059eed@jbarnes-x200>
References: <1242800768.3260.21.camel@localhost.localdomain>
	 <200905281100.21386.jarod@redhat.com>
	 <1243577795.3159.27.camel@localhost.localdomain>
	 <200905290934.14675.jarod@redhat.com>
	 <1243607316.3210.4.camel@localhost.localdomain>
	 <20090601115334.37059eed@jbarnes-x200>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:55:33 +0530
Message-Id: <1243855533.21289.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 11:53 +0100, Jesse Barnes wrote:
> On Fri, 29 May 2009 19:58:36 +0530
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Hi Andrew,
> > 
> > On Fri, 2009-05-29 at 09:34 -0400, Jarod Wilson wrote:
> > > On Friday 29 May 2009 02:16:35 Jaswinder Singh Rajput wrote:
> > > > I am not sure where this patch should go.
> > > > 
> > > > So I am also mailing to Andrew and Dave, it they find this useful
> > > > then they can add in their tree.
> > > 
> > > Dave is on vacation a bit longer, iirc. Not entirely sure where else
> > > this might go either. I'm sure *someone* will pick it up sooner or
> > > later... In any case, thanks for the fix for my flub.
> > > 
> > > Acked-by: Jarod Wilson <jarod@redhat.com>
> > > 
> > 
> > Can you accept this patch with Jarod Ack as Dave is on vacation and
> > Ingo is still busy with perfcounter ;-)
> 
> It doesn't sound urgent, or are you seeing crashes due to this?  If so
> I can queue it up to Linus (I'm taking critical fixes while Dave is
> away, though I think he's back now actually).
> 

Ok, then better wait for Dave :-)

--
JSR

