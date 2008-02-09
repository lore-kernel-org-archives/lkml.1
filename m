Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYBISKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYBISKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYBISKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:10:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34798 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYBISKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:10:00 -0500
Date: Sat, 9 Feb 2008 10:06:33 -0800
From: Greg KH <greg@kroah.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.og
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
Message-ID: <20080209180633.GB20784@kroah.com>
References: <20080209064810.GB29926@kroah.com> <842653.5028.qm@web52901.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <842653.5028.qm@web52901.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 12:06:06PM +0000, Chris Rankin wrote:
> --- Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Feb 08, 2008 at 11:31:24PM +0000, Chris Rankin wrote:
> > > I've just tried booting the 2.6.24.1 kernel, except without
> > > nmi_watchdog being enabled. It looks like there are IRQs still not
> > > being enabled.
> > 
> > Does 2.6.24 work?  Is this a 2.6.24.1 regression?
> 
> Nope, 2.6.24 doesn't work either. So there's an important fix needed
> somewhere for 2.6.24.2 ...  ;-)

Does any older kernel version work?  2.6.23?  Newer ones?  2.6.24-git15?

Any chance at trying to bisect this down to where the problem might have
occured?

thanks,

greg k-h
