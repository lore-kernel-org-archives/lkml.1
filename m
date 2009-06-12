Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZFLRFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZFLRFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFLREy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:04:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3449 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZFLREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:04:53 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 13:04:53 EDT
X-IronPort-AV: E=McAfee;i="5300,2777,5644"; a="19348493"
From: davidb@quicinc.com
Date: Fri, 12 Jun 2009 09:55:28 -0700
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       "san@android.com" <san@android.com>,
       "rlove@google.com" <rlove@google.com>, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612165528.GA31278@huya.quicinc.com>
Mail-Followup-To: Stefan Schmidt <stefan@datenfreihafen.org>,
	Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	"san@android.com" <san@android.com>,
	"rlove@google.com" <rlove@google.com>, Greg KH <greg@kroah.com>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <20090612160015.GA8942@linode.davidb.org> <20090612164325.GA12863@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612164325.GA12863@dodger.lab.datenfreihafen.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 09:43:25AM -0700, Stefan Schmidt wrote:
> Hello.
> 
> On Fri, 2009-06-12 at 09:00, David Brown wrote:
> > On Fri, Jun 12, 2009 at 05:05:04PM +0200, Pavel Machek wrote:
> > 
> > Support for these devices is in our reference kernel at:
> > 
> >     https://www.codeaurora.org/gitweb/quic/le/?p=kernel/msm.git;a=summary
> > 
> > It's also a bit unfortunate that our primary development happens on
> > development boards that aren't available to the general public.
> 
> That and that one have to sign a contributor agreement just to register on your
> your site and get in touch. While your kernel tree is public that looks a lot
> like a closed development process to me.
> 
> Any plan to make this more transparent?

We're definitely working on it.  I think the intent is to have a
Gerrit instance to accept contributions.  I'll have to look into
whether this can be done without signing the agreement.  Right
now, I can't even contribute anything, so there are a lot of
issues to work out.

David
