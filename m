Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab0APCow (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745Ab0APCos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:44:48 -0500
Received: from tango.0pointer.de ([85.214.72.216]:41138 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab0APCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:44:45 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 21:44:45 EST
Date: Sat, 16 Jan 2010 03:33:49 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Greg KH <greg@kroah.com>
Cc: Chun-Yi <jlee@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [00/02] msi-laptop patches for N034 laptop
Message-ID: <20100116023349.GA9895@tango.0pointer.de>
References: <20100115234710.GA22890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115234710.GA22890@kroah.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15.01.10 15:47, Greg KH (greg@kroah.com) wrote:

Heya,
 
> Here are 2 patches from Joey Lee for the msi-laptop driver that add
> support for the 3G button and other stuff for the new N034 laptop.
> 
> If you don't have any objections, do you want me to take them through my
> driver tree to go to Linus for the .34 kernel merge, or do you have a
> tree that they can go through?

Patches make sense to me.

Nope, I don't really maintain a tree. Please add them to your driver
tree!

Thanks,

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
