Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZICTkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZICTkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZICTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:40:54 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:33908 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbZICTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:40:53 -0400
Date: Thu, 3 Sep 2009 15:40:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Christian_Kr=E4mer?= <christian@kraemer-eu.de>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
In-Reply-To: <20090903193709.GA11097@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0909031539070.3200@localhost>
References: <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl> <200909030042.45081.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Wolfram Sang wrote:

> > Original message with lspci and dmesg output for .24 is at:
> > http://lkml.org/lkml/2009/9/2/199
>
> For a start:
>
> That line
>
> pcmcia: Detected deprecated PCMCIA ioctl usage from process:
> hwsetup...

  the pcmcia ioctl has been listed as removable since 2005:

http://lkml.org/lkml/2007/5/1/124

and is still listed that way in Doc/feature-removal-schedule.txt, you
can't say i didn't try.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
