Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZFJV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZFJV2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZFJV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:28:08 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:44931 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZFJV2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:28:07 -0400
X-Greylist: delayed 2477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2009 17:28:07 EDT
Date: Wed, 10 Jun 2009 23:28:28 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Brian Swetland <swetland@google.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Message-ID: <20090610212828.GE6251@dodger.lab.datenfreihafen.org>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610204708.GD6251@dodger.lab.datenfreihafen.org> <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.19 (2009-01-05)
Subject: Re: MSM6281 support was: HTC Dream aka. t-mobile g1 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Wed, 2009-06-10 at 14:08, Brian Swetland wrote:
> On Wed, Jun 10, 2009 at 1:47 PM, Stefan
> Schmidt<stefan@datenfreihafen.org> wrote:
> >
> > On Wed, 2009-06-10 at 13:24, Brian Swetland wrote:
> >>
> >> We have full support for MSM7201A, including fully functional power
> >> management, working on a number of commercially shipping devices that
> >> we'd absolutely love to get into mainline.
> >
> > A bit offtopic here. (subject change). Is it expected that the android kernel
> > team will also work on systems that use the MSM6K modems with different SoC's? I
> > have soem systems here that use an msm6281 on a dual port ram chip with non msm
> > SoC's. I wonder how difficult it would be to adaept the existing msm smd driver
> > to such a setup.
> 
> We only have documentation, support, and permission to do work on 7k
> and 8k family devices at this point.  I don't know anything about the
> 6k family, and how similar (or not) the shared memory interface would
> be, so unfortunately I can't provide much help there.

To bad. Thanks for the answer.

regards
Stefan Schmidt
