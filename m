Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZDGAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZDGAhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZDGAhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:37:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZDGAhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:37:41 -0400
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: Steven Rostedt <srostedt@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: GeunSik Lim <leemgs1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <alpine.LFD.2.00.0904070120090.21577@localhost.localdomain>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
	 <49b7c2350904060717l1a87cca7p880b6843ea92c702@mail.gmail.com>
	 <49b7c2350904061609q7984d5f0u478a092ffcabe12c@mail.gmail.com>
	 <alpine.LFD.2.00.0904070120090.21577@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 06 Apr 2009 20:37:14 -0400
Message-Id: <1239064634.4753.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-04-07 at 01:32 +0200, Thomas Gleixner wrote:
> GeunSik,
> 
> On Tue, 7 Apr 2009, GeunSik Lim wrote:
> 
> > Sorry,
> > I mistake because I don't understand how to submit patch exactly.
> 
> To submit a patch you need to have:
> 
> 1) useful subject line
> 
>    [PATCH] subsystem: what does the patch do
> 
>    subsystem in your care is: ftrace
> 
> 2) useful patch description
> 
>    explains what the patch does. Which bug/problem it fixes or which
>    enhancement it provides
> 
>    Look at the git log. Each commit has an (more or lesss) usefull
>    description, but you get the idea. If you see a confusing or
>    cryptic description you need way more time to figure out what the
>    patch does or what it is supposed to do.
> 
> 3) Your Signed-off-by
> 
>    Signed-off-by is the certificate of origin as described in
>    
>    Documentation/SubmittingPatches
> 
>    You can only add your own Signed-off-by. You never can add the
>    Signed-off-by of some one else.
> 
> > I just appended below "singned-off" contents for convenience.
> > Sorry again.
> > 
> >    Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
> >    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> >    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> That's how it might look later on. It would say:
> 
>        GeunSik Lim  	 wrote the patch
>        Steven Rostedt 	 picked it up from your mail and sent it to Ingo

Please send to my rostedt@goodmis.org account. From now on I'm using
that as my Signed-off-by and keep Red Hat as the author. I'm about to
travel and I do not read my Red Hat email while I'm out.

I'll pick this patch up now before I leave.

Thanks,

-- Steve

>        Ingo Molnar 	 received it from Steven's mail and applied it
> 
> There is no way for you to forsee how your patch will be picked up and
> propagated. It might go via Andrew Morton or directly to Linus. Ok ?
> 
> So you only add your own Signed-off-by.
> 
> Hope that helps. Thanks,
> 
>      tglx

