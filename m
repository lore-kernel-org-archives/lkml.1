Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYBIGnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYBIGnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYBIGnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:43:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYBIGng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:43:36 -0500
Date: Fri, 8 Feb 2008 22:48:10 -0800
From: Greg KH <greg@kroah.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.og
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
Message-ID: <20080209064810.GB29926@kroah.com>
References: <73144.97791.qm@web52909.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73144.97791.qm@web52909.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 11:31:24PM +0000, Chris Rankin wrote:
> Hi,
> 
> I've just tried booting the 2.6.24.1 kernel, except without
> nmi_watchdog being enabled. It looks like there are IRQs still not
> being enabled.

Does 2.6.24 work?  Is this a 2.6.24.1 regression?

thanks,

greg k-h
