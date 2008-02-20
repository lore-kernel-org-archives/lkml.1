Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYBTOq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYBTOq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbYBTOqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:46:21 -0500
Received: from mail58c2.megamailservers.com ([216.251.41.178]:57472 "EHLO
	mail58c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYBTOqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:46:20 -0500
X-Authenticated-User: stephan.eciinternational.de
Subject: Re: PL2303 Driver missing support for USB to Serial Cable
From: Stephan Rose <stephan@eciinternational.de>
To: Greg KH <greg@kroah.com>
Cc: David Newall <davidn@davidnewall.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080218050603.GB15141@kroah.com>
References: <1203001060.8420.11.camel@software> <47B6DC7A.3040308@gmail.com>
	 <47B6DF8C.7030106@davidnewall.com>  <20080218050603.GB15141@kroah.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 09:46:03 -0500
Message-Id: <1203518763.7002.0.camel@software>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-17 at 21:06 -0800, Greg KH wrote:
> On Sat, Feb 16, 2008 at 11:35:16PM +1030, David Newall wrote:
> > Stephan,
> > 
> > Jiri Slaby wrote:
> > > On 02/14/2008 03:57 PM, Stephan Rose wrote:
> > >> I recently purchased a USB->Com Port serial cable from Radio Shack
> > >> (Model number 26-183) which did no seem to want to work. After looking
> > >> into it I discovered that it is based on the Prolific chipset using the
> > >> PL2303 driver.
> > >
> > > Well, would you mind creating, testing and posting a patch?
> > 
> > 
> > You needn't bother.  As far as I'm concerned, what you sent is
> > sufficient and, as I am currently working on the pl2303 driver, you can
> > rest assured that it will be included in the patch that I send.
> 
> That might be pretty tough to do, as it's already in the 2.6.25-rc2
> release :)
> 
> And please, patches need to be one-thing-per-patch.  Don't try to mix
> cleanups, bug fixes, and also new devices ids all in one patch.
> 
> Stephan, thanks for the report, but someone beat you to it by a few
> weeks already, the driver is updated.

No problem, glad it's already in! :)

Thanks,

Stephan

