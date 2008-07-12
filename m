Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYGLUUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYGLUUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYGLUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:20:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:55439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYGLUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:20:10 -0400
Date: Sat, 12 Jul 2008 13:17:03 -0700
From: Greg KH <gregkh@suse.de>
To: Milton Miller <miltonm@bga.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Brian King <brking@us.ibm.com>, Jean Delvare <khali@linux-fr.org>,
       Tejun Heo <htejun@gmail.com>, Michael Ellerman <michael@ellerman.id.au>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RESEND] pci: dynids.use_driver_data considered harmful
Message-ID: <20080712201703.GA12900@suse.de>
References: <for-27-patch9@bga.com> <for-27-patch9-fix@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <for-27-patch9-fix@bga.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 03:02:22PM -0500, Milton Miller wrote:
> I typo'd on the cc to linux-kernel the first time, and wanted to take make a
> second pass at the long narritive of my debug session promoting this patch.
> I think I got the new linux-pci list, but google doesn't seem to find any
> archives of the new list or this patch.
> 
> Andrew,
> 	Thanks for picking this up and the expanded cc list.  I took the
> patch from mmotm and only changed the changlog.  Please update your copy.

Andrew, please drop this patch, it is not correct, the code should stay
as-is.  See my previous reply for why this is so.

> Jesse,
> 	I don't care if you commit this version with the full narritive
> or just the part through the footnote.

Jesse, please don't commit this either.

Milton, if you wish to ignore my response, well, that's up to you :(

thanks,

greg k-h
