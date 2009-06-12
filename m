Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbZFLRf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbZFLRf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZFLRfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:35:21 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:60306 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbZFLRfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:35:20 -0400
Date: Fri, 12 Jun 2009 19:35:37 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Stefan Schmidt <stefan@datenfreihafen.org>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       "san@android.com" <san@android.com>,
       "rlove@google.com" <rlove@google.com>, Greg KH <greg@kroah.com>
Message-ID: <20090612173537.GC12863@dodger.lab.datenfreihafen.org>
References: <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <20090612160015.GA8942@linode.davidb.org> <20090612164325.GA12863@dodger.lab.datenfreihafen.org> <20090612165528.GA31278@huya.quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612165528.GA31278@huya.quicinc.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.19 (2009-01-05)
Subject: Re: HTC Dream aka. t-mobile g1 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, 2009-06-12 at 09:55, davidb@quicinc.com wrote:
> On Fri, Jun 12, 2009 at 09:43:25AM -0700, Stefan Schmidt wrote:
> > 
> > On Fri, 2009-06-12 at 09:00, David Brown wrote:
> > > On Fri, Jun 12, 2009 at 05:05:04PM +0200, Pavel Machek wrote:
> > > 
> > > Support for these devices is in our reference kernel at:
> > > 
> > >     https://www.codeaurora.org/gitweb/quic/le/?p=kernel/msm.git;a=summary
> > > 
> > > It's also a bit unfortunate that our primary development happens on
> > > development boards that aren't available to the general public.
> > 
> > That and that one have to sign a contributor agreement just to register on your
> > your site and get in touch. While your kernel tree is public that looks a lot
> > like a closed development process to me.
> > 
> > Any plan to make this more transparent?
> 
> We're definitely working on it.

Good.

> I think the intent is to have a
> Gerrit instance to accept contributions.  I'll have to look into
> whether this can be done without signing the agreement.  Right
> now, I can't even contribute anything, so there are a lot of
> issues to work out.

Gerrit is the Android review system? I'm only interested into the kernel and
especially running a mainline kernel on different devices. Anyway, a public
review process and some more informations on what you are working and how you
would like to bring it mainline would help here.

regards
Stefan Schmidt
