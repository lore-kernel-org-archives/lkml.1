Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYDJRn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYDJRn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbYDJRnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:43:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44804 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbYDJRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:43:21 -0400
Date: Thu, 10 Apr 2008 10:42:54 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10
Message-ID: <20080410174254.GB10117@kroah.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 06:14:04PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> [I have been asked to provide a summary of changes before the biolerplate
> so here goes (please tell me if this is what you want or not).  I am not
> going to try to describe the changes in the individual trees, just the
> interactions between them.]
> 
> Changes since next-20080410:
> 
> I no longer revert "x86: phase out forced inlining".
> There is a new conflict in arch/s390/lib/uaccess_pt.c between the s390 and
> 	kvm trees.
> There is a new trivial white space conflict in arch/ia64/kernel/mca.c.
> I no longer need to revert "wusb: add the wireless usb stack to Linux".

Very nice, thanks for the summary, I appreciate it.

greg k-h
