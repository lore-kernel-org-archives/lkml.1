Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0BPNyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:54:11 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34097 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0BPNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:54:08 -0500
Date: Tue, 16 Feb 2010 14:53:56 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Message-ID: <20100216135356.GR28375@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
 <1266313885-1195-2-git-send-email-giometti@linux.it>
 <20100216153301.534f2722@desktopvm.lvknet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216153301.534f2722@desktopvm.lvknet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/8] pps: userland header file for PPS API.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 03:33:01PM +0300, Alexander Gordeev wrote:
> Hi Rodolfo,
> 
> On Tue, 16 Feb 2010 10:51:18 +0100
> Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > This patch adds into the PPS's documentation directory a possible
> > implementation of the PPS API (RFC 2783) by using the LinuxPPS's char
> > devices.
> > 
> > This file is not just an example but it can be used into real
> > systems. :)
> 
> Isn't libc a proper place for this file? This header file provides a
> generic standardized interface (PPSAPI) to the custom Linux
> implementation (linux/pps.h). I think this is just what libc is for.

You are right, but I added that file for documentation purpose also.
Just to illustrate how to implement an high level API with my simple
char device interface.

> I wanted to file a bug in Debian BTS last week to add this header to
> libc6-dev package and also push it upstream but something distracted
> me. If you agree that the header should be in libc then I can do it now.

I agree. :)

Can you please put me in Cc in your letters with the Debian people?

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
