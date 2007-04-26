Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbXDZVAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbXDZVAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbXDZVAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:00:43 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:52303 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXDZVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:00:43 -0400
Date: Thu, 26 Apr 2007 23:01:25 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com, reg@deneb.dwf.com
Message-ID: <20070426210125.GA11092@enneenne.com>
References: <20070321074121.GA13843@enneenne.com> <200703211655.l2LGtwWl017848@deneb.dwf.com> <20070321203647.GD4539@enneenne.com> <200703212235.l2LMZMQ4005361@deneb.dwf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703212235.l2LMZMQ4005361@deneb.dwf.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [LinuxPPS] [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 04:35:22PM -0600, Reg Clemens wrote:
> > On Wed, Mar 21, 2007 at 10:55:58AM -0600, Reg Clemens wrote:
> > > 
> > > Just one point with your patch.
> > > A couple of years ago there was a long discussion on the Linux Kernel mailing 
> > > list
> > > as to how USER codes were not supposed to use KERNEL include files.  Now I 
> > > still
> > > see __KERNEL__ all over the place in the linux=source includes so mabe this
> > > never went anywhere, but you MIGHT have to provide a separate patch (addition)
> > > to the Linux (as opposed to Linux-kernel) include files with timepps.h
> > 
> > Do you mean I should separate file timepps.h into two files? One for
> > the kernel and one for the userland?
> > 
> Well, Im sure you are dealing with some of the Linux Kernel people, so its
> whatever they want.  But dont be surprised if they ask for a *.h file thats 
> ONLY
> for Kernel use.  And I have NO idea how you would get the USER version into
> the Linux distribution itself.

According to this suggestion I've modified the LinuxPPS code. Please
refere to the GIT repository and the LinuxPPS wiki for further info.

Now I hope LinuxPPS can be ready for the Linux source tree! :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
