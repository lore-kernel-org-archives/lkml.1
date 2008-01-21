Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYAUAPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYAUAPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYAUAPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:15:43 -0500
Received: from rex.snapgear.com ([203.143.235.140]:45601 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754988AbYAUAPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:15:42 -0500
Message-ID: <4793E42B.7080400@snapgear.com>
Date: Mon, 21 Jan 2008 10:15:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: gerg@uclinux.org, Miles Bader <miles@gnu.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: Removal of the v850 port?
References: <20080120192356.GI8669@does.not.exist>
In-Reply-To: <20080120192356.GI8669@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk wrote:
> Is anyone maintaining the v850 port in the Linux kernel or will work on 
> getting it back into a usable state in the foreseeable future?

The only person I know who can maintain it is Miles.
Not sure if he is still active in this space though.

Regards
Greg



> Otherwise I'll send a patch to remove it.
> 
> That's not meant personally against anyone, and it would not prevent the 
> port from getting back into the kernel in the future if someone will 
> start getting it back into a usable state, but in it's current state 
> it is simply useless.
> 
> cu
> Adrian
> 
> 
> ----- Forwarded message from Adrian Bunk <bunk@kernel.org> -----
> 
> Date:  Tue, 1 Jan 2008 15:50:21 +0200
> From: Adrian Bunk <bunk@kernel.org>
> To: Miles Bader <miles@gnu.org>
> Cc: linux-kernel@vger.kernel.org
> Subject: Status of the v850 port?
> 
> Trying to compile the v850 port brings you many compile errors, one of 
> them exists since at least kernel 2.6.19.
> 
> Are there any patches in some external tree that should be merged?
> 
> Or will anyone work on getting this port back into a usable state in the 
> forseeable future?
> 
> Otherwise the only reasonable option would be to remove this port from 
> the kernel sources since it is dead code.
> 
> cu
> Adrian
> 
> ----- End forwarded message -----
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
