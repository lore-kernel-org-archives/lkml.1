Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbYDYW1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbYDYW1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYDYW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:27:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52190 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYDYW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:27:20 -0400
Date: Fri, 25 Apr 2008 15:32:48 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: torvalds@linux-foundation.org, viro@parcelfarce.linux.theplanet.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] A few documentation updates
Message-ID: <20080425223248.GB12643@kroah.com>
References: <2501.1209146908@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2501.1209146908@vena.lwn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 12:08:28PM -0600, Jonathan Corbet wrote:
> I have a few updates queued up in my documentation tree:
> 
>   git://git.lwn.net/linux-2.6 docs
> 
> Changes are:
> 
> Jonathan Corbet (3):
>       Document SEQ_SKIP
>       Various fixes to Documentation/HOWTO

No objection from me, thanks for doing this.  I do normally cc: all of
the different translation maintainers of this file when it is changed so
they know to update their translations where necessary.  Do you want me
to do that?

>    quilt trees:
> -    - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
> +    - USB, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>

Heh, I've dropped I2C a while ago as well, that should be changed :)

thanks,

greg k-h
