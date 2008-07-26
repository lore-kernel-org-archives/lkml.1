Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYGZFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYGZFMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYGZFMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 01:12:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYGZFMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 01:12:09 -0400
Date: Fri, 25 Jul 2008 22:08:59 -0700
From: Greg KH <greg@kroah.com>
To: Richard A Nelson <cowboy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch 0/9] 2.6.25-stable review
Message-ID: <20080726050859.GB18771@kroah.com>
References: <20080725230644.GA1612@suse.de> <j74l84livfi260fi8glgpd09m9q7igqnu0@4ax.com> <alpine.DEB.1.10.0807252102480.30604@hygvzn-guhyr.pnirva.bet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807252102480.30604@hygvzn-guhyr.pnirva.bet>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:07:47PM -0700, Richard A Nelson wrote:
> On Fri, 25 Jul 2008 16:06:44 -0700, Greg KH <gregkh@suse.de> wrote:
> 
> > This is the start of the stable review cycle for the 2.6.25.13 release.
> > There are 9 patches in this series, all will be posted as a response to
> > this one.
> 
> While I appreciate keeping 2.6.25 going (I still need it on two boxen
> where 2.6.26 just doesn't play nicely), I'm kind of surprised to not see
> any similar activity against 2.6.26 - is .26 orphaned, or not started
> until after the merge window ?

I'm just a bit slow in getting a .26 out.  There are patches already
queued up, and my mbox is quite full for more patches to go before it
can get out.  It was just really easy to flush the .25 patches out at
this moment.

thanks,

greg "digging the inbox out after 3 weeks of travel" k-h
