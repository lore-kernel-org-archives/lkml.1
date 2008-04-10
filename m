Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYDJM5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYDJM5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYDJM5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:57:34 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:35129 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755314AbYDJM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:57:33 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-164.messagelabs.com!1207832251!14105506!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 10 Apr 2008 14:57:09 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080410125709.GA11038@digi.com>
References: <20080207133805.13f092ff@dilbert.local> <20080207130222.GA8587@flint.arm.linux.org.uk> <20080207141236.00940d09@dilbert.local> <20080211092547.09bca061@dilbert.local> <20080410122127.GA8096@digi.com> <20080410122706.GG26575@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410122706.GG26575@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Apr 2008 12:57:10.0193 (UTC) FILETIME=[63888A10:01C89B0A]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15840.007
X-TM-AS-Result: No--15.955000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Russell King - ARM Linux wrote:
> On Thu, Apr 10, 2008 at 02:21:27PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > Hans-Jürgen Koch wrote:
> > > Am Thu, 7 Feb 2008 14:12:36 +0100
> > > schrieb Hans-Jürgen Koch <hjk@linutronix.de>:
> > > 
> > > AFAICT, this patch was neither rejected nor applied. It generated a
> > > long thread about changing the whole ARM Kconfig system. I feel not
> > > qualified to do that, but I still want UIO available on ARM ;-)
> > > What can I do to help?
> > Anything new here?
> > 
> > In my eyes this can be sent to the patch system.
> 
> I don't remember anything about this...
I don't know how I should understand your statement.  Does this only
comment on my suggestion to send it to the patch system or on the patch
itself?

After Hans-Jürgen addressed your concerns about the order in
arch/arm/Kconfig compared to drivers/Kconfig there was no addional
feedback (apart from the discussion about including drivers/Kconfig in
arch/arm/Kconfig).

I consider the patch good until arch/arm/Kconfig includes
drivers/Kconfig (if ever).

As it is a while that the discussion took place, here is the thread in
the archive:

	http://lists.arm.linux.org.uk/lurker/thread/20080207.125824.348cd1bd.en.html

and the following post includes the last version of the patch:

	http://lists.arm.linux.org.uk/lurker/message/20080207.131236.8c4f4569.en.html

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
