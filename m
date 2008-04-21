Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbYDUQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbYDUQAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYDUQAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:00:34 -0400
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:34683 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755651AbYDUQAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:00:33 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: PCI MAINTAINER change
Date: Mon, 21 Apr 2008 08:55:28 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
References: <20080421062139.GA4901@suse.de> <20080421062806.GA4919@suse.de>
In-Reply-To: <20080421062806.GA4919@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210855.28405.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 20, 2008 11:28 pm Greg KH wrote:
> On Sun, Apr 20, 2008 at 11:21:39PM -0700, Greg KH wrote:
> > Here are a some PCI and PCI hotplug patches against your 2.6.25 git tree.
> >
> > They contain:
> > 	- documentation movement into a new directory
> > 	- pci section warning fixes
> > 	- more generic PCI code for some arches
> > 	- removal of the duplicated list of all PCI devices in the system
> > 	- second go-around for the PCI ASPM code
> > 	- various bugs and other minor stuff
> > 	- change the PCI maintainer
>
> I just wanted to highlight this last entry.  I'm passing the PCI
> subsystem maintainership on to Jesse Barnes <jbarnes@virtuousgeek.org>
>
> I'd like to thank him for volunteering for the job, something for which
> I know he is more than capable.
>
> So those of you who have automated scripts to hit me with PCI
> issues/bugs/complaints, might want to adjust them at this point in time.
>
> Now what to do with all of this extra free time I'm going to have...

And now I get to figure out just how much trouble I've gotten myself into...

Thanks for all the time you've put into it, Greg.  Maybe your extra free time 
can be spent on that 5th driver core re-write you've been talking about. :)

Thanks,
Jesse

