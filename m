Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbZE0Jjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbZE0Jjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbZE0JjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:39:25 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48516 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbZE0JjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:39:24 -0400
Date: Wed, 27 May 2009 11:38:50 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org
Message-ID: <20090527093850.GC15594@enneenne.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
	sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
	kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org
References: <1242972753-22992-1-git-send-email-giometti@linux.it> <1242972753-22992-2-git-send-email-giometti@linux.it> <20090526163333.052026f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526163333.052026f6.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:33:33PM -0700, Andrew Morton wrote:

> Well it seems that Christoph's header file suggestion was addressed.

Yes, I fixed it.

> It's been a long time and there have been many reviews and comments. 
> Have you been keeping track of them all?
> 
> If so, can you please let us know which review comments remain
> unaddressed, or were deliberately not addressed because you disagreed
> with them?

I fixed everything but didn't include George Spelvin
<linux@horizon.com>'s pathes (see them here
http://ml.enneenne.com/pipermail/linuxpps/2009-February/002788.html)
because after a (very) long discussion (please, refer also to some
private messages to you from myself and George) we agree to wait for a
new patchset from him but, after several weeks, I still receive
nothing so I decided to addres the header file issue and repropose my
implementation which is currenlty used into several systems.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
