Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYDMUkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYDMUkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYDMUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:39:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37295 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYDMUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:39:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #10434] 2.6.25-rc8: FTP transfer errors
Date: Sun, 13 Apr 2008 22:40:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru,
       ilpo.jarvinen@helsinki.fi, jeff@garzik.org, lkml@rtr.ca,
       xemul@openvz.org, yoshfuji@linux-ipv6.org
References: <oq66hWjeF4N.A.yJ.L3lAIB@albercik> <200804132202.55395.rjw@sisk.pl> <20080413.133045.123268955.davem@davemloft.net>
In-Reply-To: <20080413.133045.123268955.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132240.20668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of April 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 13 Apr 2008 22:02:54 +0200
> 
> > On Sunday, 13 of April 2008, David Miller wrote:
> > > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
> > > 
> > > This patch is in Linus's tree and thus the bug is fixed.
> > 
> > Hm, "git whatchanged net/ipv4/inet_timewait_sock.c" returns
> > 
> > commit 7951f0b03a63d657c72c7d54d306ef3357e7e604
> > Author: Daniel Lezcano <dlezcano@fr.ibm.com>
> > Date:   Thu Apr 10 20:53:10 2008 -0700
> > 
> >     [NETNS][IPV6] tcp - assign the netns for timewait sockets
> > 
> > as the most recent commit changing that file ...
> > 
> > It doesn't look like the patch has been merged yet.
> 
> That's exactly the fix, what are you talking about?

You're right, sorry (I was confused by the fact that Yoshifuji sent the message
with it).

Entry closed.

Thanks,
Rafael
