Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497Ab0A1XdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0A1XdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349Ab0A1XdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:33:00 -0500
Received: from kroah.org ([198.145.64.141]:38794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab0A1Xc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:32:58 -0500
Date: Thu, 28 Jan 2010 15:31:50 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, linux-kernel@vger.kernel.org,
       lsb-discuss@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux wireless GSoC 2010 project ideas
Message-ID: <20100128233150.GB31884@kroah.com>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
 <20100128231545.GH18683@nowhere>
 <43e72e891001281523s56707279x896ab059e6d4e530@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e891001281523s56707279x896ab059e6d4e530@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 03:23:15PM -0800, Luis R. Rodriguez wrote:
> On Thu, Jan 28, 2010 at 3:15 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I'm sorry if I'm a bit off-topic. But as I see this announce,
> > I'm wondering about the topics for the google summer of code
> > in the wider scope of the entire kernel.
> >
> > I'm a student and there are fair chances I'll be free for this
> > summer so I start to think about applying.
> >
> > Are there currently some plans concerning other kernel areas?
> 
> These would be under the Linux Foundation umbrella, the wireless stuff
> I just posted is just for wireless. I do not believe we have a common
> forum yet for general linux stuff. Till?

Traditionally, PSU (Portland State University) handles a number of Linux
kernel related projects for GSoC due to the Linux kernel developers who
are mentors for them, and the faculty who are very clued into the kernel
and x.org and general open source development.

Also, the way that PSU handles the projects, is it relies on the
students to propose the projects, not the other way around.  Due to
that, the success rate is very high as people do not generally propose
things that they do not have some kind of interest in :)

So if you have a kernel related project you wish to do, feel free to
submit it to the PSU group.

thanks,

greg k-h

p.s. I've been a mentor for the PSU GSoC group for many years now.
