Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0BPN4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:56:18 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34127 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab0BPN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:56:17 -0500
Date: Tue, 16 Feb 2010 14:56:12 +0100
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
Message-ID: <20100216135612.GS28375@enneenne.com>
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
 <1266313885-1195-3-git-send-email-giometti@linux.it>
 <20100216154456.2cea05d2@desktopvm.lvknet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216154456.2cea05d2@desktopvm.lvknet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 2/8] pps: documentation programs and examples.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 03:44:56PM +0300, Alexander Gordeev wrote:
> On Tue, 16 Feb 2010 10:51:19 +0100
> Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > Here some utilities and examples about the PPS API and the LinuxPPS
> > support.
> > 
> > * ppstest.c implements an useful testing program, while
> > 
> > * ppsfind tries to help the user into finding a specific PPS source by
> >   using its name or path.
> 
> Maybe these tools should be in a separate package (say pps-tools)? I've
> written several tools too. They are based on your code. I think there
> should be at least two of them:
> 
>  * ppsctl to get/set params, get capabilities and bind/unbind kernel
> consumer
> 
>  * ppstest to fetch data and provide several representations for it
> 
> I can assist in this task too.

Great! It's ok for me. Please, let me know how we can proceed.

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
