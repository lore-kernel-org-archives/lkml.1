Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZFJWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZFJWKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbZFJWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:10:45 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:55639 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZFJWKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:10:44 -0400
Date: Thu, 11 Jun 2009 00:10:54 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marek Vasut <marek.vasut@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Brian Swetland <swetland@google.com>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>, san@android.com,
       rlove@google.com
Message-ID: <20090610221054.GF6251@dodger.lab.datenfreihafen.org>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610204708.GD6251@dodger.lab.datenfreihafen.org> <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com> <200906102328.40140.marek.vasut@gmail.com> <20090610213259.GA8224@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610213259.GA8224@elf.ucw.cz>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.19 (2009-01-05)
Subject: Re: MSM6281 support was: HTC Dream aka. t-mobile g1 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Wed, 2009-06-10 at 23:33, Pavel Machek wrote:
> On Wed 2009-06-10 23:28:39, Marek Vasut wrote:
> > On Wednesday 10 of June 2009 23:08:36 Brian Swetland wrote:
> > > On Wed, Jun 10, 2009 at 1:47 PM, Stefan
> > >
> > > Schmidt<stefan@datenfreihafen.org> wrote:
> > > > Hello.
> > > >
> > > > On Wed, 2009-06-10 at 13:24, Brian Swetland wrote:
> > > >> We have full support for MSM7201A, including fully functional power
> > > >> management, working on a number of commercially shipping devices that
> > > >> we'd absolutely love to get into mainline.
> > > >
> > > > A bit offtopic here. (subject change). Is it expected that the android
> > > > kernel team will also work on systems that use the MSM6K modems with
> > > > different SoC's? I have soem systems here that use an msm6281 on a dual
> > > > port ram chip with non msm SoC's. I wonder how difficult it would be to
> > > > adaept the existing msm smd driver to such a setup.
> > >
> > > We only have documentation, support, and permission to do work on 7k
> > > and 8k family devices at this point.  I don't know anything about the
> > > 6k family, and how similar (or not) the shared memory interface would
> > > be, so unfortunately I can't provide much help there.
> > 
> > Palm Pre apparently uses MSM68xx as a baseband chip, otherwise is omap3 based.
> > The device is out, selling, but I haven't seen any kernel patches from them 
> > yet. I hope they release them in a few weeks (even though they should have 
> > been out already).
> 
> If you can get your hands on Palm Pre, it should come with
> GPL-required sources or offer for source code... if it does not, talk
> to Harald Welte (gpl-violations.org)....

They have the licence inside and offer source on request on the letter. I wrote
them a mail some hours ago and they state that all source will be on
http://opensource.palm.com/ within two weeks.

regards
Stefan Schmidt
