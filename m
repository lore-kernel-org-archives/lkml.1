Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYDMUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYDMUaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYDMUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:30:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38621
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbYDMUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:30:44 -0400
Date: Sun, 13 Apr 2008 13:30:45 -0700 (PDT)
Message-Id: <20080413.133045.123268955.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru,
       ilpo.jarvinen@helsinki.fi, jeff@garzik.org, lkml@rtr.ca,
       xemul@openvz.org, yoshfuji@linux-ipv6.org
Subject: Re: [Bug #10434] 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804132202.55395.rjw@sisk.pl>
References: <oq66hWjeF4N.A.yJ.L3lAIB@albercik>
	<20080413.124823.173625519.davem@davemloft.net>
	<200804132202.55395.rjw@sisk.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 13 Apr 2008 22:02:54 +0200

> On Sunday, 13 of April 2008, David Miller wrote:
> > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
> > 
> > This patch is in Linus's tree and thus the bug is fixed.
> 
> Hm, "git whatchanged net/ipv4/inet_timewait_sock.c" returns
> 
> commit 7951f0b03a63d657c72c7d54d306ef3357e7e604
> Author: Daniel Lezcano <dlezcano@fr.ibm.com>
> Date:   Thu Apr 10 20:53:10 2008 -0700
> 
>     [NETNS][IPV6] tcp - assign the netns for timewait sockets
> 
> as the most recent commit changing that file ...
> 
> It doesn't look like the patch has been merged yet.

That's exactly the fix, what are you talking about?
