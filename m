Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbXEJK7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbXEJK7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXEJK7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:59:15 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:45057 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXEJK7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:59:14 -0400
Date: Thu, 10 May 2007 12:58:37 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Message-ID: <20070510105837.GB979@enneenne.com>
References: <20070321074121.GA13843@enneenne.com> <20070502193314.GA23367@enneenne.com> <20070510002740.c4350813.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510002740.c4350813.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:27:40AM -0700, Andrew Morton wrote:
> 
>   Please check with Dave Miller that this:
> 
> 	#define NETLINK_PPSAPI          20
> 
>   reservation is OK.

Hello, as you can see here Andrew Morton asked to me to check with you
about NETLINK_PPSAPI reservation.

Please, let me know if it's ok.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
