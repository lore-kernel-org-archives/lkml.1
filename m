Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXINUoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXINUoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXINUoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:44:01 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:51444 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXINUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:44:00 -0400
Date: Fri, 14 Sep 2007 22:43:44 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Steven Toth <stoth@hauppauge.com>, Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Message-ID: <20070914204343.GA9058@linuxtv.org>
References: <20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <20070914113838.GA29962@linuxtv.org> <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 87.162.112.115
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007, Markus Rechberger wrote:
> 
> people do contribute to the em28xx project.
...
> there's also an active and even problem solving oriented ML available:
> http://mcentral.de/pipermail/em28xx/
> 
> Also if you look at the mercurial code you'll see several people
> contributing to that project.

Of course, people who own such a device and want to use
it with Linux have no choice but to work with you.
And you do a good job for your users, you support them
well and in return they contribute info and patches
to support new devices.

But the thing is that at mcentral.de you're the man at the top,
and your users will hardly disagree with you on core
technical questions. (Well, admittedly I'm speculating
here as I don't read your em28xx list.)

On for drivers/media/ OTOH you are just one developer among others,
and some of them choose to disagree with you. Even worse,
IIRC there wasn't even _a single_ other developer willing
to ACK your offending patch.

Now, doesn't _that_ get you thinking?


Johannes
