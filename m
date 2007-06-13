Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXFMXzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXFMXzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXFMXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:55:39 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:64147 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbXFMXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:55:38 -0400
Date: Wed, 13 Jun 2007 19:55:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Shane <gnome42@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH RT] fix migrating softirq [cause of network hang]
In-Reply-To: <fa4052ef0706131520x619ff3f5ke23cf649b8ff2b79@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0706131954220.20636@gandalf.stny.rr.com>
References: <fa4052ef0706131414o27b2281bp81d3f5b3d3104f87@mail.gmail.com> 
 <Pine.LNX.4.58.0706131723430.20636@gandalf.stny.rr.com>
 <fa4052ef0706131520x619ff3f5ke23cf649b8ff2b79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Shane wrote:

> On 6/13/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > I have applied this patch to 2.6.21.4-rt13 and I think it might have
> > > solved my bizarre nfs hangage issues that cropped up lately. Thanks
> > > for tracking that down it was driving me nutz!
> > >
> > > It has only been a few hours, but if you don't hear back from me in
> > > the next day or so then it's good to go IMVHO. :)
> > >
> >
> > Hi Shane,
> >
> > That's great to hear!  Well, if it does go well, could you post to LKML
> > and linux-rt mailing lists, as well as CC'ng Ingo. Good news like this
> > should be shared ;-)
> >
> > Heh, even if it doesn't go well, you can post to the above too.
>
> Heh, I spoke too soon. This patch doesn't seem to help my problem after all. :/
>

Really?  Darn.

So it seemed to work? Just curious to why you thought it worked and but it
didn't?

-- Steve

