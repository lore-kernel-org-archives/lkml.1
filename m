Return-Path: <linux-kernel-owner+w=401wt.eu-S937716AbXGRXph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937716AbXGRXph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763466AbXGRXlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:41:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41983 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912AbXGRXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:41:13 -0400
Date: Wed, 18 Jul 2007 16:40:20 -0700
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070718234020.GA5971@kroah.com>
References: <200707171703.31340.rob@landley.net> <20070718095857.5365323a@gondolin.boeblingen.de.ibm.com> <200707181339.54192.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181339.54192.rob@landley.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:39:53PM -0400, Rob Landley wrote:
> PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!
> 
> I don't care where it is.  Just put it somewhere I can find it, and keep it 
> there.  All this gratuitous moving stuff around serves NO PURPOSE other than 
> to break userspace.  I'm trying to document this so that the next time you 
> go "oh wait, it should be at "/sys/tarantula/fruitbat" I can show that you're 
> breaking an existing documented userspace API.
> 
> There's a kernel config option to make symlinks from the old 
> location.  /sys/block makes as much sense as any other location, and it's 
> what's there now.

Read the sysfs documentation file we just added, it describes how this
is all documented and should be used.  So well that I do not think you
need to try to document it again.

thanks,

greg k-h
