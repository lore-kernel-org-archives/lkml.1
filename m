Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbYADKea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbYADKea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYADKeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:34:20 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:34428 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935AbYADKeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:34:20 -0500
Date: Fri, 4 Jan 2008 19:33:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Ben Dooks <ben@fluff.org>,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       bryan.wu@analog.com
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080104103345.GA15184@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>, Ben Dooks <ben@fluff.org>,
	linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
	bryan.wu@analog.com
References: <20080103160104.171f9aaa@zod.rchland.ibm.com> <20080103160406.7ef5ecfe@zod.rchland.ibm.com> <20080103224139.GA4178@fluff.org.uk> <20080103165854.0d6accef@zod.rchland.ibm.com> <20080104040119.GA10268@linux-sh.org> <20080104091928.GA28547@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104091928.GA28547@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:19:28AM +0000, Russell King wrote:
> On Fri, Jan 04, 2008 at 01:01:19PM +0900, Paul Mundt wrote:
> > On Thu, Jan 03, 2008 at 04:58:54PM -0600, Josh Boyer wrote:
> > > On Thu, 3 Jan 2008 22:41:40 +0000
> > > Ben Dooks <ben@fluff.org> wrote:
> > > 
> > > > On Thu, Jan 03, 2008 at 04:04:06PM -0600, Josh Boyer wrote:
> > > > > Rework the architecture specific Makefiles to use the in-kernel version of
> > > > > the mkubootimg tool.
> > > > > 
> > > > > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> > > > 
> > > > A CC: to RMK and any other arch maintainers being touched by this
> > > > would have useful too.
> > > 
> > > D'oh.  I thought I had fixed that in this round.  Bit late now, but
> > > CC'd.
> > > 
> > Looks fine to me.
> > 
> > Acked-by: Paul Mundt <lethal@linux-sh.org>
> 
> No sign of a patch.  So no ack from me.

Indeed, it would be nice to actually be CC'ed on the patch itself at the
time of submission without having to dig through the list archives for
it. Hopefully the next iteration gets this right, as well as Haavard's
email address ;-)
