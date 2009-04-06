Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbZDFXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbZDFXcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDFXcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:32:36 -0400
Received: from www.tglx.de ([62.245.132.106]:37583 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZDFXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:32:36 -0400
Date: Tue, 7 Apr 2009 01:32:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: GeunSik Lim <leemgs1@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
In-Reply-To: <49b7c2350904061609q7984d5f0u478a092ffcabe12c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904070120090.21577@localhost.localdomain>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>  <49b7c2350904060717l1a87cca7p880b6843ea92c702@mail.gmail.com> <49b7c2350904061609q7984d5f0u478a092ffcabe12c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GeunSik,

On Tue, 7 Apr 2009, GeunSik Lim wrote:

> Sorry,
> I mistake because I don't understand how to submit patch exactly.

To submit a patch you need to have:

1) useful subject line

   [PATCH] subsystem: what does the patch do

   subsystem in your care is: ftrace

2) useful patch description

   explains what the patch does. Which bug/problem it fixes or which
   enhancement it provides

   Look at the git log. Each commit has an (more or lesss) usefull
   description, but you get the idea. If you see a confusing or
   cryptic description you need way more time to figure out what the
   patch does or what it is supposed to do.

3) Your Signed-off-by

   Signed-off-by is the certificate of origin as described in
   
   Documentation/SubmittingPatches

   You can only add your own Signed-off-by. You never can add the
   Signed-off-by of some one else.

> I just appended below "singned-off" contents for convenience.
> Sorry again.
> 
>    Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
>    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>

That's how it might look later on. It would say:

       GeunSik Lim  	 wrote the patch
       Steven Rostedt 	 picked it up from your mail and sent it to Ingo
       Ingo Molnar 	 received it from Steven's mail and applied it

There is no way for you to forsee how your patch will be picked up and
propagated. It might go via Andrew Morton or directly to Linus. Ok ?

So you only add your own Signed-off-by.

Hope that helps. Thanks,

     tglx
