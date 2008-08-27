Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYH0QZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYH0QZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYH0QYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:24:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbYH0QYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:24:06 -0400
Date: Wed, 27 Aug 2008 09:19:43 -0700
From: Greg KH <greg@kroah.com>
To: Denis Joseph Barrow <D.Barow@option.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: question wrt /drivers/char/tty_io.c in pre 2.6.16 code
Message-ID: <20080827161943.GF19710@kroah.com>
References: <20080820010353.593820280@mini.kroah.org> <20080820010752.GB3365@kroah.com> <48B52064.9070700@pobox.com> <48B578F3.1050908@option.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B578F3.1050908@option.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:55:31PM +0200, Denis Joseph Barrow wrote:
> Hi all,
> In kernels prior to 2.6.16

Hm, why do we care about kernels that are 2 1/2 years old?  We can't do
anything to modify them at this point in time and the only ones
supporting them are the enterprise distros.

thanks,

greg k-h
