Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYA3Bo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYA3Bo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYA3Bor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:44:47 -0500
Received: from keil-draco.com ([216.193.185.50]:50248 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYA3Boq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:44:46 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Date: Tue, 29 Jan 2008 20:44:33 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <1201641765.18773.35.camel@dv> <20080130003519.GB1802@does.not.exist> <yw1x4pcw3zu9.fsf@mansr.com>
In-Reply-To: <yw1x4pcw3zu9.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801292044.34309.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 19:46:06 Måns Rullgård wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> > On Tue, Jan 29, 2008 at 11:25:22PM +0000, Måns Rullgård wrote:
> >> Adrian Bunk <bunk@kernel.org> writes:
> >> > On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
> >> >> Hello!
> >> >>
> >> >> It have come to my attention that a patch has been committed to the
> >> >> kernel with the explicit purpose of tainting ndiswrapper - the kernel
> >> >> module allowing Windows NDIS drivers for Ethernet and Wireless cards
> >> >> to be used by the kernel.
> >> >>...
> >> >> Just to reiterate some points from the old discussion:
> >> >>...
> >> >> - no copyright violation is involved, as Windows drivers are not
> >> >> derived from Linux sources
> >> >>...
> >> >
> >> > It is interesting that someone posting with an @gnu.org address claims
> >> > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> >> > not a copyright violation.
> >>
> >> As long as you don't distribute /proc/kcore, I can't see how the GPL
> >> would have any say in the matter.  The Windows drivers are (unrelated
> >> violations aside) clearly not derived from GPL code.

Only because of the distribution of the windows driver. As I understand US and 
International copyright law, dynamic linking cannot create a new, derivative 
work and hence cannot carry its own license. (It's a "machine translation") 
What that means is that there is no violation of the GPL if GPL'd code is 
linked to proprietary code and then distributed. However, the GPLv3 does have 
language in it that would require the proprietary code to also be 
distributed.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
