Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYIQQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYIQQVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYIQQVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:21:05 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:41966 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYIQQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:21:03 -0400
Message-ID: <48D12E3B.3030201@csr.com>
Date: Wed, 17 Sep 2008 17:20:11 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: torvalds@linux-foundation.org
Subject: Re: New subsystems: Ultra-Wideband radio, Wireless USB and WiMedia
 LLC Protocol
References: <48AD6AF0.3050504@csr.com>
In-Reply-To: <48AD6AF0.3050504@csr.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 16:20:11.0695 (UTC) FILETIME=[425E3BF0:01C918E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel wrote:
> I'm the maintainer of the Ultra-Wideband (UWB) radio, Certified Wireless
> USB (WUSB) and WiMedia LLC Protocol (WLP) subsystems.  These are now in
> a state were I consider them suitable for inclusion into the kernel.
> 
> UWB is a new high speed, short range radio technology (480 Mbit/s at 1
> m, 53.3 Mbit/s at 10 m).  The specifications are freely available and
> are managed by the WiMedia Alliance.   For more information see
> http://www.wimedia.org/.
> 
> Various protocols run on top of the UWB radio: Certified Wireless USB
> (WUSB); WiMedia LLC Protocol (WLP), for IP (etc) networks; and (in the
> future) high speed Bluetooth.

There is now a git tree for these subsystems.

git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git

You will want the 'for-upstream' branch.  This should be finding its way
into linux-next shortly.

Linus, please advise on when a pull request for the 2.6.28 merge window
should be made.  e.g., should it be before the merge window opens or
during the window?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
