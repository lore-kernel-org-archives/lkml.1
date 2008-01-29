Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYA2Xox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYA2Xox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYA2Xod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:44:33 -0500
Received: from c60.cesmail.net ([216.154.195.49]:47374 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760637AbYA2Xoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:44:32 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
In-Reply-To: <20080129225701.GS8767@does.not.exist>
References: <1201641765.18773.35.camel@dv>
	 <20080129225701.GS8767@does.not.exist>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:44:27 -0500
Message-Id: <1201650267.18773.118.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 00:57 +0200, Adrian Bunk wrote:
> On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
> > Hello!
> > 
> > It have come to my attention that a patch has been committed to the
> > kernel with the explicit purpose of tainting ndiswrapper - the kernel
> > module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> > be used by the kernel.
> >...
> > Just to reiterate some points from the old discussion:
> >...
> > - no copyright violation is involved, as Windows drivers are not derived
> > from Linux sources
> >...
> 
> It is interesting that someone posting with an @gnu.org address claims
> that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> not a copyright violation.

No, I'm representing myself only.  I don't think you represent all
kernel developers when posting from the kernel.org address.

I'm actually surprised that you are raising this issue.  If the
motivation to ban ndiswrapper is based on the copyright law, doesn't it
meant that we have DRM in the kernel now?  Is Linux going to enforce
copyright laws across the world?

> Is it an official statement of the FSF that such linking is considered 
> legal?

Absolutely not.

> (RMS added to Cc)

I, for one, would welcome an informed position of the FSF.  It may have
interesting implications for Wine, ReactOS, mplayer, qemu, Java and many
other programs loading non-free compiled code at the run time.

-- 
Regards,
Pavel Roskin
