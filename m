Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXBXVCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXBXVCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbXBXVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:02:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:54064 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559AbXBXVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RTR2y/b42pFDedGZeXW9VQ0UBuSLjcQCzMTwernVIVDXfv//789IBHfj3wZCiZ5KABmp+ggcDu3fmtC6gB0Em6yJ+B4fMBGhqOuq+U1D1c5+ZU43/AKuqJMy4dmzqS8qgoJRnyU8zRsxOp+EeZuNTOozZ8A5IHUQHdXp1ZVmoEQ=
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20070223124557.GA13443@localhost.localdomain>
References: <20070209193405.GB2637@localhost.localdomain>
	 <1172102733.4217.38.camel@daplas>
	 <20070223124557.GA13443@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 05:04:28 +0800
Message-Id: <1172351068.4415.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 13:45 +0100, Ondrej Zajicek wrote:
> On Thu, Feb 22, 2007 at 08:05:33AM +0800, Antonino A. Daplas wrote:
> > On Fri, 2007-02-09 at 20:34 +0100, Ondrej Zajicek wrote: 
> > > This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> > > with most versions of S3 Trio and S3 Virge, on i386.
> > > It is tested both as compiled-in and module. It is against
> > > linux-2.6.20 .
> > > 
> > > This is version 3. There are some minor modifications from version 2
> > > (mostly coding style cleanups).
> > 
> > Nice, the first driver to use tileblit :-)
> > 
> > Since this driver is already in the -mm tree, can you resubmit a diff
> > against that? 
> 
> This driver was removed from -mm tree, because it is in 2.6.21-rc1 .
> So it is probably unnnecessary to resubmit a diff, isn't it?
> 

Okay, I thought the one in the tree was an older version. Thanks for
clarifying.

Tony


