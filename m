Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYFMSEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYFMSEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYFMSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:04:27 -0400
Received: from mail.queued.net ([207.210.101.209]:3046 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYFMSEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:04:25 -0400
Date: Fri, 13 Jun 2008 14:10:49 -0400
From: Andres Salomon <dilinger@queued.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080613141049.0fb3a770@ephemeral>
In-Reply-To: <20080521214723.GB15136@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org>
	<20080502190949.GA30270@uranus.ravnborg.org>
	<20080521164703.61c7d715@ephemeral>
	<20080521214723.GB15136@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 23:47:23 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, May 21, 2008 at 04:47:03PM -0400, Andres Salomon wrote:
> > On Fri, 2 May 2008 21:09:49 +0200
> > Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > With the attached patch you can do:
> > > 
> > > make K=my_favourite_config defconfig
> > > 
> > > kconfig will read all config values form 'my_favourite_config'
> > > and set all other symbols to their default value.
> > > The output is now dense like this:
> > > # configuration is based on 'my_favourite_config'
> > > #
> > > # configuration written to .config
> > > #
> > > 
> > 
> > 
> > Is this slated for 2.6.27?
> 
> Been busy and got sidetracked after my first version proved broken.
> Will try to look at it in the weekend.
> 
> 	Sam


Any updates on this?  I've been forced to use a workaround in the
meantime..
