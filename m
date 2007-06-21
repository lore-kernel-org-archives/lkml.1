Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbXFURvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbXFURvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbXFURux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:50:53 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34196
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbXFURuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:50:52 -0400
Date: Thu, 21 Jun 2007 10:51:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Michael Poole <mdpoole@troilus.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070621174332.GD10008@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0706211046511.31603@asgard.lang.hm>
References: <871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com>
 <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm> <87sl8ms9z5.fsf@graviton.dyn.troilus.org>
 <Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm> <87k5tys8w5.fsf@graviton.dyn.troilus.org>
 <Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm> <87645is82q.fsf@graviton.dyn.troilus.org>
 <20070621171612.GC10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706211019510.31603@asgard.lang.hm>
 <20070621174332.GD10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Lennart Sorensen wrote:

> On Thu, Jun 21, 2007 at 10:26:04AM -0700, david@lang.hm wrote:
>> the bios doesn't have enough capability to talk to the outside world for
>> updates.
>
> Of course, although perhaps it could.  More likely my thought was that
> the service when it decides to download an update, would include the
> updated bios image and put it on the boot drive where the existing bios
> can find it.  No signature needs to be added to the boot drive or
> kernel, just checksums in the bios image.
>
>> what tivo actually does is very similar to this
>>
>> they encode into the bios the ability to check a checksum/signature for
>> the kernel+boot filesystem and if they don't match look to see if there is
>> another kernel+boot filesystem available
>>
>> then software on the boot filesystem checks to see if the rest of the
>> system has been tampered with before it mounts /

you snippede the bit about not knowing how to stop it

>> the GPLv3 is trying to do this.
>
> Perhaps they should just explicitly say that then.

they call the section the anti-tivoization, how much more explicit can 
they get?

David Lang

by the way, just in case anyone is misunderstanding me. I don't believe 
for a moment that all these anti-tamper features actually work in the real 
world (the PS3 hacking kits are proof of the lengths people will go to to 
make the 'hard' hardware-level hacking trivial to do) but the approach 
needs to be at secure modulo hardware tampering or software bugs.

