Return-Path: <linux-kernel-owner+w=401wt.eu-S1765193AbZFLQn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765193AbZFLQn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZFLQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:43:17 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:41152 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZFLQnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:43:16 -0400
Date: Fri, 12 Jun 2009 18:43:25 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: David Brown <davidb@quicinc.com>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Message-ID: <20090612164325.GA12863@dodger.lab.datenfreihafen.org>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <20090612160015.GA8942@linode.davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612160015.GA8942@linode.davidb.org>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.19 (2009-01-05)
Subject: Re: HTC Dream aka. t-mobile g1 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, 2009-06-12 at 09:00, David Brown wrote:
> On Fri, Jun 12, 2009 at 05:05:04PM +0200, Pavel Machek wrote:
> 
> Support for these devices is in our reference kernel at:
> 
>     https://www.codeaurora.org/gitweb/quic/le/?p=kernel/msm.git;a=summary
> 
> in the android-msm-2.6.29 branch, which is about 213 commits divergent
> from Google's tree, posted earlier.  We've been trying to work to get
> our commits to be closer to being appropriate for inclusion in the
> mainstream kernel.  Sadly, most of out work so far ended up being
> squashed into a single "Initial contribution" commit.
> 
> It's also a bit unfortunate that our primary development happens on
> development boards that aren't available to the general public.

That and that one have to sign a contributor agreement just to register on your
your site and get in touch. While your kernel tree is public that looks a lot
like a closed development process to me.

Any plan to make this more transparent?

regards
Stefan Schmidt
