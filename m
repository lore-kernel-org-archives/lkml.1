Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0BIWlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:41:07 -0500
Received: from kroah.org ([198.145.64.141]:51928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0BIWlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:41:06 -0500
Date: Tue, 9 Feb 2010 14:38:51 -0800
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Anatolij Gustschin <agust@denx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, jcrigby@gmail.com,
       dzu@denx.de, wd@denx.de
Subject: Re: [PATCH v2 0/3] powerpc: mpc5121: PSC UART support
Message-ID: <20100209223849.GA13716@kroah.com>
References: <1265750032-2803-1-git-send-email-agust@denx.de>
 <fa686aa41002091418q2e97919ft2bcf8ad02e050afa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa41002091418q2e97919ft2bcf8ad02e050afa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 03:18:57PM -0700, Grant Likely wrote:
> Greg, since this touches powerpc stuff, do you mind if I pick up the
> series into my tree?

No objection at all, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patches.

thanks,

greg k-h
