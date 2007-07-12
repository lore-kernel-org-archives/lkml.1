Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXGLGEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXGLGEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXGLGEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:04:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43373 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXGLGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:03:59 -0400
Date: Wed, 11 Jul 2007 23:00:47 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070712060047.GC12637@kroah.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46585953.80200@imap.cc> <20070526090117.dda72286.akpm@linux-foundation.org> <465A033C.3070400@imap.cc> <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com> <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com> <465C5AF9.20601@imap.cc> <20070529192511.24924171@gondolin.boeblingen.de.ibm.com> <20070601123848.GH7426@kroah.com> <20070703105040.2afd2bcf@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703105040.2afd2bcf@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 10:50:40AM +0200, Cornelia Huck wrote:
> On Fri, 1 Jun 2007 05:38:48 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> [Sorry for taking so long to respond, I've been offline for a month]
> 
> > Can you resend me the new patch, I seem to have lost it in this thread
> > :(
> 
> Andrew has the fixup patch in his -mm lineup as
> driver-core-check-return-code-of-sysfs_create_link-fix.patch. Do you
> need anything else?

No, that should be fine, I'll pull it from him there.

thanks,

greg k-h
