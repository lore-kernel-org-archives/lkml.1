Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXINLjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXINLjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXINLjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:39:01 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:42507 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXINLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:39:00 -0400
Date: Fri, 14 Sep 2007 13:38:38 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Steven Toth <stoth@hauppauge.com>, Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Message-ID: <20070914113838.GA29962@linuxtv.org>
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com> <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com> <20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 84.190.142.128
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007, Markus Rechberger wrote:
> On 9/14/07, Steven Toth <stoth@hauppauge.com> wrote:
> >
> > If you care about LinuxTV you'll work with the core subsystem developers
> > to bring your em28xx tree inline. If you don't care then why are you here?
> 
> It doesn't really work out to work with those 3-5 "core" people who are active
> there.
> It starts at the point where RFCs are submitted and not answered,
> discussions are avoided and finally some people start to complain.
> In case of pointing people to wrong or bad solutions, one "Maintainer"
> pointed out it would be like manipulating others work ... this exactly
> happened with the em28xx project. It's not only about the current
> implementation, as from my side I also take upcoming products into
> account and how long it would take to get something which isn't
> supported by the API fixed.. it's just something that is too hard and
> I don't want to debate about things where I know that the outcome
> is that I have to wait till someone of those 3-5 "core" people come up
> with an own idea.

Maybe you still don't realize how tiresome it is to talk to you.
What you present as "linuxtv people block my contributions" is
IMHO "linuxtv people got fed up talking to you". Because when
people disagree with you, you keep rambling on and on instead
of just accepting it. See, working with an Open source community
requires that you don't piss everyone off, but instead find
ways to _motivate_ them to help you fix the problems which
prevent your code from being merged. When people are doing
software development _for fun_, then it should be a _pleasure_
for them to work with you, and not a pain in the ass.

You code and your arguments in this discussion may be
different than before, but the thread follows a familiar
pattern and will likely go nowhere, just like the many
discussions before.


Johannes
