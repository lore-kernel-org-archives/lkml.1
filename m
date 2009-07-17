Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbZGQTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbZGQTro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZGQTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:47:44 -0400
Received: from kroah.org ([198.145.64.141]:35560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbZGQTrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:47:43 -0400
Date: Fri, 17 Jul 2009 12:43:00 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch 00/30] 2.6.27-stable review
Message-ID: <20090717194300.GA29341@kroah.com>
References: <20090701002817.GA6156@kroah.com>
 <1246427880@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246427880@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 08:04:34AM +0200, Christoph Biedl wrote:
> Greg KH wrote...
> 
> > This is the start of the stable review cycle for the 2.6.27.26 release.
> 
> Please consider
> 
> | commit 1f8ae0a21d83f43006d7f6d2862e921dbf2eeddd
> | Author: Tomasz Lemiech <szpajder@staszic.waw.pl>
> | Date:   Fri Mar 13 15:43:38 2009 -0700
> | 
> |     tulip: Fix for MTU problems with 802.1q tagged frames
> 
> for inclusion which was added in 2.6.30 - although probably I am the
> last one in the world who uses VLANs on tulip.  That patch applied on
> 2.6.27.25 and worked for me.  If I should do another test on top of
> 2.6.27.26-rc1, drop me a line.

Now queued up.

thanks,

greg k-h
