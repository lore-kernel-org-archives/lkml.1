Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbXEKAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbXEKAa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbXEKAaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:30:20 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:56051 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbXEKAaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:30:19 -0400
Date: Fri, 11 May 2007 02:30:12 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070511003012.GP11009@enneenne.com>
References: <20070502193314.GA23367@enneenne.com> <20070510002740.c4350813.akpm@linux-foundation.org> <20070510105837.GB979@enneenne.com> <20070510.040152.39159048.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510.040152.39159048.davem@davemloft.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Info about the new netlink layer userland API
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 04:01:52AM -0700, David Miller wrote:
> 
> It's not OK, please use the generic netlink interface and as
> such you will not need to allocate any numbers at all.
> 
> Documentation/networking/generic_netlink.txt gives a link
> to some infomration on this topic.

Where can I find some infos about userland programming _without_ using
the libnl library?

There are something similar to the magic command:

   ret = socket(PF_NETLINK, SOCK_RAW, NETLINK_PPSAPI);

in this new netlink API?

Thanks for your help,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
