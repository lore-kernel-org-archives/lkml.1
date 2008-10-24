Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYJXDD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYJXDD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJXDDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:03:20 -0400
Received: from mail.crca.org.au ([67.207.131.56]:44047 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYJXDDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:03:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: Current suspend issues on Lenovo X200
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nico Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200810240006.19857.rjw@sisk.pl>
References: <20081023204326.GB4175@denkbrett.schottelius.org>
	 <20081023210707.GA5089@denkbrett.schottelius.org>
	 <200810240006.19857.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Organization: Christian Reformed Churches of Australia
Date: Fri, 24 Oct 2008 14:03:14 +1100
Message-Id: <1224817394.6623.12.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rafael :)

On Fri, 2008-10-24 at 00:06 +0200, Rafael J. Wysocki wrote:
> On Thursday, 23 of October 2008, Nico Schottelius wrote:
> > First of all, this was wrong:
> > 
> > Nico -telmich- Schottelius [Thu, Oct 23, 2008 at 10:43:26PM +0200]:
> > >  - 2.6.27: system freeze instead of wakeup
> > >    -> shows parts of the X screen, but does not react on ping
> > 
> > System does not freeze, but reboots instead.
> > 
> > Tried next-20081023 and 2.6.27 with acpi_sleep=s3_bios:
> > 
> > - suspend and wakeup on console works fine for both!
> > - no X running on next
> > - 2.6.27 + X -> reboot on wakeup
> 
> Let me guess, you have a NVidia graphics?

Not this time. Going off the other log he posted, it's...

Chipset Mobile Intel® GM45 Express Chipset found

Regards,

Nigel

