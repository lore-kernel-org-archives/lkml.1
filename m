Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZDGBZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZDGBZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZDGBZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:25:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:39114 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZDGBZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LSyuY6el7uv3/vbvoP7dUS8Rqhh9pBbAHFN3rbEF1skK32P0GKe+7bq1AvE47faIGH
         E9ZC4NBlwqbet1P/+Y31nyJArlWPYX3hj1dIEeYO9uzt9jCJ9yiYc5W6zyBLF312XZGY
         vB8Q4hhL0nfg8MHUFW2QoGZgk/chz6ERPYisg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904070120090.21577@localhost.localdomain>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
	 <49b7c2350904060717l1a87cca7p880b6843ea92c702@mail.gmail.com>
	 <49b7c2350904061609q7984d5f0u478a092ffcabe12c@mail.gmail.com>
	 <alpine.LFD.2.00.0904070120090.21577@localhost.localdomain>
Date: Tue, 7 Apr 2009 10:25:26 +0900
Message-ID: <28c262360904061825n6728509ey7933fefdaae35f9f@mail.gmail.com>
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: Minchan Kim <minchan.kim@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: GeunSik Lim <leemgs1@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more thing.

Please, Not attach your patch but inline one.
Many people want to add their comments to line-by-line.

Tip -
If you use gmail with web, your patch is mangled by web server.
That will hurt maintainers.

Documentation/email-clients.txt can help you. :)

On Tue, Apr 7, 2009 at 8:32 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> GeunSik,
>
> On Tue, 7 Apr 2009, GeunSik Lim wrote:
>
>> Sorry,
>> I mistake because I don't understand how to submit patch exactly.
>
> To submit a patch you need to have:
>
> 1) useful subject line
>
>   [PATCH] subsystem: what does the patch do
>
>   subsystem in your care is: ftrace
>
> 2) useful patch description
>
>   explains what the patch does. Which bug/problem it fixes or which
>   enhancement it provides
>
>   Look at the git log. Each commit has an (more or lesss) usefull
>   description, but you get the idea. If you see a confusing or
>   cryptic description you need way more time to figure out what the
>   patch does or what it is supposed to do.
>
> 3) Your Signed-off-by
>
>   Signed-off-by is the certificate of origin as described in
>
>   Documentation/SubmittingPatches
>
>   You can only add your own Signed-off-by. You never can add the
>   Signed-off-by of some one else.
>
>> I just appended below "singned-off" contents for convenience.
>> Sorry again.
>>
>>    Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
>>    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> That's how it might look later on. It would say:
>
>       GeunSik Lim       wrote the patch
>       Steven Rostedt    picked it up from your mail and sent it to Ingo
>       Ingo Molnar       received it from Steven's mail and applied it
>
> There is no way for you to forsee how your patch will be picked up and
> propagated. It might go via Andrew Morton or directly to Linus. Ok ?
>
> So you only add your own Signed-off-by.
>
> Hope that helps. Thanks,
>
>     tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
Minchan Kim
