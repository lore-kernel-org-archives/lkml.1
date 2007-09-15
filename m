Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXIONeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXIONeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXIONd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:33:58 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:36809 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbXIONd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:33:57 -0400
Date: Sat, 15 Sep 2007 15:34:18 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Steven Toth <stoth@hauppauge.com>, Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Message-ID: <20070915133418.GB12531@linuxtv.org>
References: <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <20070914113838.GA29962@linuxtv.org> <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com> <20070914204343.GA9058@linuxtv.org> <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 87.162.108.9
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007, Markus Rechberger wrote:
> The main discussion in this thread was about drivers in userspace
> are bad because the API will allow binary drivers. The guy
> who works for Hauppauge (again I also have good contacts
> at Hauppauge Europe) writes it's bad - for no technical reason.

It sends a shiver down my spine that seem to imply that you
use your Hauppauge Europe contact to lobby against the
efforts of Hauppauge USA employees to promote support for
Open Source kernel drivers within their company.

> If someone points out that it is bad (after reading the whole thread)
> why don't we put X.org, bash, well everything into the kernel?
> GPL is the saviour seems to be the saviour for some people in this
> world, but in the end it's still if people want to go that way.
> Much work has been done by other people before, my work
> is also just an additional contribution and I (again) don't intend to
> release binary drivers. (also keep in mind that ubuntu takes
> everything which makes things work - this matters to the enduser)
> 
> Hey I can also write I can help you to get things right with some other
> people, and I can financially support people by giving away
> hardware and even specs for free in some cases. Who is able
> to do that from the old crufted v4l/dvb guys?
> 
> Manu throws his drivers over the wall to the OSS community, although
> I don't mind.
> Mauro is copying the logic of my code and writes I told him I'm ok with
> taking my code without just adding a single line of how his driver
> got developed. (I still wonder why he skipped some significant parts
> of the driver .. because he used the existing one as logic template)
> 
> http://linuxtv.org/hg/~mchehab/tm6000-new/log/14352ab89146/linux/drivers/media/video/tuner-xc2028.c
> (not looking at the specific changeset but he copied the firmware
> loading instructions without taking care about the copyright?)

After you dismissed all arguments except your own as invalid, you've
now moved on to the "post bullshit and personal accusations" stage.
I hope this means we're now done with this "discussion".

> > Now, doesn't _that_ get you thinking?
> 
> oh yes.

Yeah, right.


Johannes
