Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXCUWh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXCUWh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965410AbXCUWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:37:26 -0400
Received: from c-69-254-139-13.hsd1.nm.comcast.net ([69.254.139.13]:57579 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965369AbXCUWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:37:24 -0400
Message-Id: <200703212235.l2LMZMQ4005361@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Reg Clemens <reg@dwf.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com, reg@deneb.dwf.com, reg@deneb.dwf.com
Subject: Re: [LinuxPPS] [PATCH 1/1] LinuxPPS: Pulse per Second support for 
 Linux
In-reply-to: <20070321203647.GD4539@enneenne.com> 
References: <20070321074121.GA13843@enneenne.com> <200703211655.l2LGtwWl017848@deneb.dwf.com> <20070321203647.GD4539@enneenne.com>
Comments: In-reply-to Rodolfo Giometti <giometti@enneenne.com>
   message dated "Wed, 21 Mar 2007 21:36:47 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Mar 2007 16:35:22 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 21, 2007 at 10:55:58AM -0600, Reg Clemens wrote:
> > 
> > Just one point with your patch.
> > A couple of years ago there was a long discussion on the Linux Kernel mailing 
> > list
> > as to how USER codes were not supposed to use KERNEL include files.  Now I 
> > still
> > see __KERNEL__ all over the place in the linux=source includes so mabe this
> > never went anywhere, but you MIGHT have to provide a separate patch (addition)
> > to the Linux (as opposed to Linux-kernel) include files with timepps.h
> 
> Do you mean I should separate file timepps.h into two files? One for
> the kernel and one for the userland?
> 
Well, Im sure you are dealing with some of the Linux Kernel people, so its
whatever they want.  But dont be surprised if they ask for a *.h file thats 
ONLY
for Kernel use.  And I have NO idea how you would get the USER version into
the Linux distribution itself.

-- 
                                        Reg.Clemens
                                        reg@dwf.com


