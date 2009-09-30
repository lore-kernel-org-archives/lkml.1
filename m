Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZI3X3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZI3X3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZI3X3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:29:05 -0400
Received: from kroah.org ([198.145.64.141]:39634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZI3X3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:29:03 -0400
Date: Wed, 30 Sep 2009 16:27:57 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, stable@kernel.org
Subject: Re: [stable] [patch for 2.6.31-stable] zaurus c3000 aka spitz: fix
 resume
Message-ID: <20090930232757.GA17069@kroah.com>
References: <20090930203251.GA1893@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930203251.GA1893@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 10:32:52PM +0200, Pavel Machek wrote:
> 
> 
> Spitz resume was broken for year or likely two, and it would be very
> nice to fix it for 2.6.31-stable release. One liner is below...
> 
> It is in 2.6.32-rc1/2, with some more signoffs...

Now queued up.

Next time please let me know what the git commit id is for the patch,
it's necessary for me to be able to include it in the -stable tree.

thanks,

greg k-h
