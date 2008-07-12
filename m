Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYGLU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYGLU7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYGLU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:59:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18223 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYGLU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:59:11 -0400
Date: Sat, 12 Jul 2008 22:58:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Milton Miller <miltonm@bga.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Brian King <brking@us.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RESEND] pci: dynids.use_driver_data considered harmful
Message-ID: <20080712225853.15b13c86@hyperion.delvare>
In-Reply-To: <20080712201703.GA12900@suse.de>
References: <for-27-patch9@bga.com>
	<for-27-patch9-fix@bga.com>
	<20080712201703.GA12900@suse.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Milton,

On Sat, 12 Jul 2008 13:17:03 -0700, Greg KH wrote:
> On Sat, Jul 12, 2008 at 03:02:22PM -0500, Milton Miller wrote:
> > I typo'd on the cc to linux-kernel the first time, and wanted to take make a
> > second pass at the long narritive of my debug session promoting this patch.
> > I think I got the new linux-pci list, but google doesn't seem to find any
> > archives of the new list or this patch.
> > 
> > Andrew,
> > 	Thanks for picking this up and the expanded cc list.  I took the
> > patch from mmotm and only changed the changlog.  Please update your copy.
> 
> Andrew, please drop this patch, it is not correct, the code should stay
> as-is.  See my previous reply for why this is so.

Care to copy it here? Apparently it all happened in a private
discussion.

> > Jesse,
> > 	I don't care if you commit this version with the full narritive
> > or just the part through the footnote.
> 
> Jesse, please don't commit this either.
> 
> Milton, if you wish to ignore my response, well, that's up to you :(

-- 
Jean Delvare
