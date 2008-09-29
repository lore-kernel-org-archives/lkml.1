Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYI2J2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYI2J2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYI2J2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:28:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:48328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYI2J2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kQFzIeg005b2CKG3tM9TooSbYyjrpp0/LtB4osO1x+VuokjvxbverJcP6CWZ427lmk
         tzbEbUqLsXZNWZBIzDPhWlrhIxEXsdwoIBbC6Et+3B40zSKMN8T+bY0rcPyk5Z1y/hTC
         yqcLWG03P7KAvllLsYpW2I79W2v9a6s/1WfDs=
Message-ID: <c62985530809290228w2aae150dk97749159bd495c3b@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:28:33 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new type of print_line
Cc: "Pekka Paalanen" <pq@iki.fi>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080929090231.GD2190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DD0347.5070008@gmail.com>
	 <20080928192909.30e0f5dd@daedalus.pq.iki.fi>
	 <20080929090231.GD2190@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/29 Ingo Molnar <mingo@elte.hu>:
>
> * Pekka Paalanen <pq@iki.fi> wrote:
>
>> > +           return TRACE_TYPE_HANDLED;
>> >     }
>> >  }
>>
>> Otherwise, very good.
>>
>> As Ingo reverted the two earlier patches, you need to rebase these
>> two. I'd like to see these in upstream. Let's handle the pipe closing
>> bug in a different patch.
>
> good. Frederic, please just resubmit all fixes you have against
> tip/master, with Pekka's Acked-by added. You can submit Pekka's patch as
> well, so that it's a coherent series. The customary way for that is to
> add in a From line as the first line of the changelog:
>
>  From: Pekka Paalanen <pq@iki.fi>
>
> and add your signoff to the end of the changelog. This way Git will show
> Pekka as the author and the path of the patch is well understood.
>

Ok so... I resend my patches (without changes?) but I adapt them to
latest -tip master?
And I add the pekka's patches (whit appropriate "from" line) with them?

Sorry I 'm a bit lost....
