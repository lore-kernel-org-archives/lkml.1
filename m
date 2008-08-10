Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYHJLIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYHJLIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYHJLIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:08:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40786 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYHJLIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:08:44 -0400
Date: Sun, 10 Aug 2008 14:07:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Jean Delvare <khali@linux-fr.org>, "D. Kelly" <user.kernel@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080810110705.GD16146@cs181140183.pp.htv.fi>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com> <20080807131357.59399ddf@hyperion.delvare> <Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net> <20080807181416.5de4ce6d@hyperion.delvare> <Pine.LNX.4.58.0808071621060.22108@shell2.speakeasy.net> <20080808113753.03f49efe@hyperion.delvare> <Pine.LNX.4.58.0808081037080.3151@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0808081037080.3151@shell2.speakeasy.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 10:52:05AM -0700, Trent Piepho wrote:
> On Fri, 8 Aug 2008, Jean Delvare wrote:
> > On Thu, 7 Aug 2008 16:41:10 -0700 (PDT), Trent Piepho wrote:
> > > Expecting every developer to keep abreast of linux-next and the tens of
> > > thousands of patches it gets just isn't realisitic.
> > >
> > > The embedded platforms I develop on won't run linux-next.  Continuously
> > > porting them to linux-next is simply impossible.  The man hours required to
> > > do that would be staggering.
> >
> > Once again a "believe me it's impossible" without any good reason
> > given. I fail to see why embedded platforms would be any different from
> > other platforms or subsystem trees. Please enlighten me.
> 
> Because they usually require lots of additional patches that aren't in the
> kernel.  Sometimes embedded developers try to get these patches into the
> mainline kernel, but some maintainers aren't interested in accepting
> patches that don't appear to be useful to desktop users.
>...

The last thing mustn't happen.

Can you give examples?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

