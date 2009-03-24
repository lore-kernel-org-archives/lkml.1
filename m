Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZCXCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZCXCjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZCXCjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 22:39:04 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:49276 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbZCXCjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 22:39:03 -0400
Message-ID: <49C847C6.4030904@lougher.demon.co.uk>
Date: Tue, 24 Mar 2009 02:39:02 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam>
In-Reply-To: <20090323180808.2c2ef1a7@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> It is great that squashfs is finally in mainline kernel. But the
> squashfs tools are tightly bound to the version of the squashfs filesystem.
> The latest tools in Debian (and the download page) are limited to 
> version 3.4 but the upstream kernel version is 4.0!
> 
> Do we have a cart with no horse here?
> 

The horse is currently in training, or to put it more mundanely, the
squashfs 4.0 tools are currently in Squashfs CVS :-)

I have been working on the 4.0 squashfs tools for the last couple of
months making them (mksquashfs and unsquashfs) ready for a supported
release.  Now that Linux 2.6.29 has been released (3 hours ago), I
need to make this release ASAP, which as everything is almost finished,
should be sometime this week.

Phillip





