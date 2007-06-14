Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXFNTNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXFNTNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXFNTN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:13:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37459 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXFNTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:13:25 -0400
Date: Thu, 14 Jun 2007 12:14:24 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, i2c@lm-sensors.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [i2c] i2c module aliases
Message-ID: <20070614191424.GA13850@kroah.com>
References: <Pine.LNX.4.64.0706062325270.30244@anakin> <20070607175342.3006e872@hyperion.delvare> <20070607160214.GB17800@kroah.com> <20070608153516.28fd9eb5@hyperion.delvare> <Pine.LNX.4.64.0706081647310.9505@anakin> <20070609125221.2a64ba48@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609125221.2a64ba48@hyperion.delvare>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 12:52:21PM +0200, Jean Delvare wrote:
> On Fri, 8 Jun 2007 16:48:45 +0200 (CEST), Geert Uytterhoeven wrote:
> > On Fri, 8 Jun 2007, Jean Delvare wrote:
> > > OK. Geert, care to submit a new patch removing struct i2c_device_id
> > > altogether?
> > 
> > Sorry, probably not...
> > 
> > I just thought I found a grave bug while looking into adding zorro
> > support to scripts/mod/file2alias.c, so that's why I reported it.
> 
> OK, no problem. I gave it a try myself. Greg, is it OK or did I miss
> other parts which can be removed?

Looks good to me.  Want me to take this through my tree or through
yours?

thanks,

greg k-h
