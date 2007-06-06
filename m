Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbXFFRrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbXFFRrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXFFRq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:46:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52722 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXFFRq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:46:56 -0400
Date: Wed, 6 Jun 2007 19:17:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
Message-ID: <20070606171711.GA5918@uranus.ravnborg.org>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de> <9a8748490706060851g59f3043ah82a0390ffc2b290b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490706060851g59f3043ah82a0390ffc2b290b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:51:24PM +0200, Jesper Juhl wrote:
> On 06/06/07, Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de> wrote:
> >Hello,
> >
> >I have a machine here which I installed with Ubuntu 7.04. Immediately
> >after the installation had been finished, I installed the Ubuntu package
> >which contains the Ubuntu-modified sources of the linux kernel. I
> >extracted the resulting tar.bz2-file, copied the configuration of the
> >currently running kernel to .config and created a file localversion-irb
> >which contains the line "-irb" and then called "make menuconfig".
> 
> You forgot "make oldconfig". When you copy in a .config file from a
> different kernel, always do oldconfig (just get in the habbit, if the
> .config from the same kernel it's harmless).
Christoph used menuconfig so his configuration was perfectly OK and
oldconfig would not have changed anything.

	Sam
