Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbXFRApz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbXFRApz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761380AbXFRApn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:45:43 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:6338 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759483AbXFRApm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:45:42 -0400
Date: Sun, 17 Jun 2007 19:45:38 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: Bron Gondwana <brong@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070618004538.GA1283823@hiwaay.net>
References: <fa.toMqQ3LqoQn6Xh51bVordO8WMVc@ifi.uio.no> <fa.EmnDne9QndTLcw7NAzc83tWplMI@ifi.uio.no> <fa.G+0vGcF8U8pcd6ozkdhKGsQ/dDs@ifi.uio.no> <fa.8bXRW7nY7z5eXVZxCxUgra+gbb8@ifi.uio.no> <fa.qtDtq+aSKlNweTqHtKcy/Gj5PXg@ifi.uio.no> <20070617215840.GA1217855@hiwaay.net> <20070617232221.GB14098@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617232221.GB14098@brong.net>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Bron Gondwana <brong@fastmail.fm> said:
> To be fair here, this could also be accomplished by having to flip a
> physical switch on the router, especially if you did something funky
> like:
> 
> [---] push this button for a 5 minute access pass to upload new
>       software through physical cable port 1.
> 
> More complex, but not unreasonable.

Well, there is no restriction on putting files on the routing engine's
storage devices (flash and hard drive); it is running OpenSSH, so
scp/sftp work fine, and you can drop to a shell easily.  The restriction
is that the kernel won't run unsigned binaries.

Also, flipping physical switches is pretty much an unreasonable
expectation for core router operation.  These are often in other
locations, sometimes other telcos' central offices (where you have to
pay to have "remote hands" do something and then hope they don't screw
it up).  You can easily go the entire life of a device where the primary
operators never physically see the device.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
