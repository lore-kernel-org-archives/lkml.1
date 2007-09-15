Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXIORc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXIORc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXIORct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:32:49 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:45442 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXIORcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:32:48 -0400
X-Greylist: delayed 2057 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 13:32:48 EDT
Date: Sat, 15 Sep 2007 18:58:34 +0200
From: Bernard Jungen <bern8817@euphonynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070915165834.GA2054@euphonynet.be>
References: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <20070914113838.GA29962@linuxtv.org> <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com> <20070914204343.GA9058@linuxtv.org> <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com> <20070915131650.GA12531@linuxtv.org> <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com> <1189865082.5271.91.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189865082.5271.91.camel@gaivota>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 11:04:42AM -0300, Mauro Carvalho Chehab wrote:
> With respect to your kernel-userspace API for xc3028, you made something
> that seemed to be a dream: there's a consensus: not a single developer
> believed that this is the better way; nobody seems that this is the
> better approach.
> 
> So, or you are the only media developer with good sense in the face of
> the Earth, or you're incapable of understand the obvious: you're wrong
> with this approach. IMO, the answer is quite obvious.

Yes, as a newbie observer on the v4l list, the answer is obvious to me,
at last, and the reason is not entirely technical. I can't read so many
bogus arguments on so few lines without reacting.

Rephrasing Mauro:

"Not a single developer out of a few SEEMS to believe that it is the BETTER
approach, so since the FEW represent ALL media developers in the world, and
since there is only ONE RIGHT way to do things, and since the GROUP is
always RIGHT and always knows better than the individual, then YOU're WRONG
and I'm right. Conform to the group and do as the group says, whatever the
consequences!"

Geeks are decidedly as prone as others to blindly accept travelling on the
slippery road of herd mentality and "obvious" conclusions based on
appearances. Is this OPEN source development or a dictatorship or what?

So in the end Mauro will be right. And Markus will continue to develop and
defend his stuff as HE sees fit. He knows his own work better than anyone
else. It will be HIS way or nothing with his own stuff, it's his inalienable
right.

And don't be naive, if there's no solution more viable than Markus' one,
then the latter will eventually be widely adopted somehow, sometime,
whatever the amount of grumbling from the establishment. No
dictatorship/forced consensus can decide future's direction, nor improve
its already low own viability.

Cheers,

Bernard.
