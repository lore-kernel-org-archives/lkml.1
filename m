Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXCURTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXCURTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXCURTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:19:41 -0400
Received: from c-69-254-139-13.hsd1.nm.comcast.net ([69.254.139.13]:47545 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933040AbXCURTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:19:40 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 13:19:39 EDT
Message-Id: <200703211655.l2LGtwWl017848@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: Rodolfo Giometti <giometti@enneenne.com>
cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com, reg@deneb.dwf.com
Subject: Re: [LinuxPPS] [PATCH 1/1] LinuxPPS: Pulse per Second support for 
 Linux
In-reply-to: <20070321074121.GA13843@enneenne.com> 
References: <20070321074121.GA13843@enneenne.com>
Comments: In-reply-to Rodolfo Giometti <giometti@enneenne.com>
   message dated "Wed, 21 Mar 2007 08:41:21 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Mar 2007 10:55:58 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just one point with your patch.
A couple of years ago there was a long discussion on the Linux Kernel mailing 
list
as to how USER codes were not supposed to use KERNEL include files.  Now I 
still
see __KERNEL__ all over the place in the linux=source includes so mabe this
never went anywhere, but you MIGHT have to provide a separate patch (addition)
to the Linux (as opposed to Linux-kernel) include files with timepps.h


-- 
                                        Reg.Clemens
                                        reg@dwf.com


