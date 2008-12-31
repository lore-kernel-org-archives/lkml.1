Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYLaOX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYLaOX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYLaOXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:23:17 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:56784 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbYLaOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:23:16 -0500
Message-ID: <495B8042.1080001@knaff.lu>
Date: Wed, 31 Dec 2008 15:22:58 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, greg@kroah.com,
       Roland <devzero@web.de>
Subject: Re: The bzip2/lzma patches
References: <495ADD46.7080601@zytor.com> <495B319B.5080601@knaff.lu> <20081231134218.GC2388@uranus.ravnborg.org>
In-Reply-To: <20081231134218.GC2388@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi Alain.
> 
>> If I may suggest something: what if *YOU* provided a patch (or series of
>> patches, or whatever you like) complying to your high stylistic
>> requirements
> 
> hpa does not have any high stylistic requirments he just have good taste.
> He simply ask you do do a better job and if you want this in then
> please follow his advice.
> 
> Asking him to do the job you want to have done is just not the way forward.
> 
> 	Sam

Thanks for the advice. You're right, this is not the way forward. I must
admit that I did indeed an huge mistake with this patch.

I've initially developed it a couple of years ago for use in udpcast.
Once done, regular attention was needed for it to adapt it to new
kernels. At one point in time (this September), I figured that I could
save that maintenance effort by getting it integrated into the mainline
kernel. At the same time, I figured, other developers of embedded
systems could profit from it. A win-win situation. Or so I thought.

However, now that I look back on the 3 past months, I figure that the
amount of effort that I poured into this was disproportionate compared
to what I used to spend on maintaining it out of kernel. Even if I
continued evolving it until the end of my life, I would spend _less_
time on it than I did in the last 3 months.

My conclusion is that I'll continue like I did before last summer: to
maintain it on my own website (http://udpcast.linux.lu/source.html)
along with udpcast.

Anybody is still welcome to use it as he sees fit. If a brave soul with
more patience than me wants to plead with the powers-that-be to get it
into official kernel, he has my support. But for myself, I give up on
this quest, it is simply too much hassle to be worthwhile...

Regards,

Alain

