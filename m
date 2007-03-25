Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXCYQ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXCYQ0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXCYQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:26:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50610 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXCYQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:26:31 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 12:26:31 EDT
Date: Sun, 25 Mar 2007 08:55:21 -0700
From: Greg KH <greg@kroah.com>
To: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
Cc: usagi-core@linux-ipv6.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: (usagi-core 32638) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL]
	[USB] fixed to skip NULL entry in struct serial usb_serial_port.
Message-ID: <20070325155521.GA11663@kroah.com>
References: <20070325.005227.432838064.takamiya@linux-ipv6.org> <20070324212253.GA26215@kroah.com> <20070325.144740.432839277.takamiya@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325.144740.432839277.takamiya@linux-ipv6.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 02:47:40PM +0900, Noriaki TAKAMIYA wrote:
> Hi,
> 
> >> Sat, 24 Mar 2007 14:22:53 -0700
> >> [Subject: (usagi-core 32638) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct serial usb_serial_port.]
> >> Greg KH <greg@kroah.com> wrote...
> 
> > This should already be fixed in the -git snapshots that have come out
> > after 2.6.21-rc4.  Can you test them to verify this?
> 
>   Yes, this problem was already fixed.

Great, thanks for testing.  So I guess both of these patches are no
longer necessary, right?

thanks,

greg k-h
