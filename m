Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbYHDTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbYHDTzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbYHDTzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:55:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60710 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbYHDTzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:55:11 -0400
Date: Mon, 4 Aug 2008 12:54:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Add mISDN driver
Message-Id: <20080804125409.6a40ad2d.randy.dunlap@oracle.com>
In-Reply-To: <20080727010837.GA3415@pingi.kke.suse.de>
References: <20080727010837.GA3415@pingi.kke.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 03:08:37 +0200 Karsten Keil wrote:

> Please pull this and the following patches from 
> git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> 
> mISDN is a new modular ISDN driver, in the long term it should replace
> the old I4L driver architecture for passiv ISDN cards.


> diff --git a/Documentation/isdn/README.mISDN b/Documentation/isdn/README.mISDN
> new file mode 100644
> index 0000000..cd8bf92
> --- /dev/null
> +++ b/Documentation/isdn/README.mISDN
> @@ -0,0 +1,6 @@
> +mISDN is a new modular ISDN driver, in the long term it should replace

   mISDN is a new modular ISDN driver. In the long term, it should replace

> +the old I4L driver architecture for passiv ISDN cards.

                                       passive

> +It was designed to allow a broad range of applications and interfaces
> +but only have the basic function in kernel, the interface to the user

                                    in kernel. The interface

> +space is based on sockets with a own address family AF_ISDN.

                                  its own address family AF_ISDN.



Sorry about the delayed response.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
