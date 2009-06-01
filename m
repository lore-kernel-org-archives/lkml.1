Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZFAKx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZFAKx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZFAKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:53:48 -0400
Received: from outbound-mail-135.bluehost.com ([67.222.39.25]:50050 "HELO
	outbound-mail-135.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756337AbZFAKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:53:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=o2FelcXDiaMi8GndkBw0MBd3/xsIcPyaEEr1x2WTgnkWFLpofueRjNqqkGLuDhgJR5EK0anwTkCTcDn8F8vCzq51Ae8+ws+WYZgRoNEBsiSs2HExi4DArL820CkmPNbH;
Date: Mon, 1 Jun 2009 11:53:34 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Airlie <airlied@linux.ie>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jarod Wilson <jarod@redhat.com>, drm list <dri-devel@lists.sf.net>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, mjg@redhat.com
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch
 warning
Message-ID: <20090601115334.37059eed@jbarnes-x200>
In-Reply-To: <1243607316.3210.4.camel@localhost.localdomain>
References: <1242800768.3260.21.camel@localhost.localdomain>
	<200905281100.21386.jarod@redhat.com>
	<1243577795.3159.27.camel@localhost.localdomain>
	<200905290934.14675.jarod@redhat.com>
	<1243607316.3210.4.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 19:58:36 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hi Andrew,
> 
> On Fri, 2009-05-29 at 09:34 -0400, Jarod Wilson wrote:
> > On Friday 29 May 2009 02:16:35 Jaswinder Singh Rajput wrote:
> > > I am not sure where this patch should go.
> > > 
> > > So I am also mailing to Andrew and Dave, it they find this useful
> > > then they can add in their tree.
> > 
> > Dave is on vacation a bit longer, iirc. Not entirely sure where else
> > this might go either. I'm sure *someone* will pick it up sooner or
> > later... In any case, thanks for the fix for my flub.
> > 
> > Acked-by: Jarod Wilson <jarod@redhat.com>
> > 
> 
> Can you accept this patch with Jarod Ack as Dave is on vacation and
> Ingo is still busy with perfcounter ;-)

It doesn't sound urgent, or are you seeing crashes due to this?  If so
I can queue it up to Linus (I'm taking critical fixes while Dave is
away, though I think he's back now actually).

Jesse
