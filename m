Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXFURnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXFURnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbXFURne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:43:34 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:33429 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbXFURnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:43:33 -0400
Date: Thu, 21 Jun 2007 13:43:32 -0400
To: david@lang.hm
Cc: Michael Poole <mdpoole@troilus.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070621174332.GD10008@csclub.uwaterloo.ca>
References: <871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com> <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm> <87sl8ms9z5.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm> <87k5tys8w5.fsf@graviton.dyn.troilus.org> <Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm> <87645is82q.fsf@graviton.dyn.troilus.org> <20070621171612.GC10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706211019510.31603@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706211019510.31603@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:26:04AM -0700, david@lang.hm wrote:
> the bios doesn't have enough capability to talk to the outside world for 
> updates.

Of course, although perhaps it could.  More likely my thought was that
the service when it decides to download an update, would include the
updated bios image and put it on the boot drive where the existing bios
can find it.  No signature needs to be added to the boot drive or
kernel, just checksums in the bios image.

> what tivo actually does is very similar to this
> 
> they encode into the bios the ability to check a checksum/signature for 
> the kernel+boot filesystem and if they don't match look to see if there is 
> another kernel+boot filesystem available
> 
> then software on the boot filesystem checks to see if the rest of the 
> system has been tampered with before it mounts /
> 
> the GPLv3 is trying to do this.

Perhaps they should just explicitly say that then.

--
Len Sorensen
