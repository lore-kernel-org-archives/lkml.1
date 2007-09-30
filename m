Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXI3OIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXI3OIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbXI3OIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:08:24 -0400
Received: from alnrmhc11.comcast.net ([204.127.225.91]:57971 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbXI3OIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:08:24 -0400
Subject: Re: Unexpected segfaults with 2.6.23-rc-8-git4
From: Chris Holvenstot <cholvenstot@comcast.net>
To: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1191159712.6517.12.camel@localhost>
References: <1191159712.6517.12.camel@localhost>
Content-Type: text/plain
Date: Sun, 30 Sep 2007 09:10:30 -0500
Message-Id: <1191161430.6517.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention it in my initial post - although I am running an
AMD64 CPU - I am using the 32 bit version of the system

On Sun, 2007-09-30 at 08:41 -0500, Chris Holvenstot wrote:
> Good Morning - 
> 
> This morning I built the 2.6.23-rc8-git4 version of the kernel.  After
> rebooting I was unable to keep my mail client (evolution) up and running
> for more than a few minutes at a time.
> 
> A look in the log shows the following message when evolution aborts:
> 
>  kernel: [ 1716.971128] evolution[10212]: segfault at 00000054 eip
> b74bbf63 esp bfc84b20 error 4
> 
>  kernel: [ 1835.797215] evolution[10335]: segfault at 00000056 eip
> b745ef63 esp bfd9db20 error 4
> 
>  kernel: [ 1854.752324] evolution[10565]: segfault at 0000045f eip
> b747ef63 esp bfa9c140 error 4
> 
> After falling back to 2.6.23-rc8-git3 I am no longer seeing this failure
> (at least not yet)
> 
> My system is built on an AMD 64 X2 4600+ with 2 gig of memory, two SATA
> and three PATA drives.  I am running what is basically a UBUNTU 7.04
> system.
> 
> I am a certified dummy when it comes to diagnosing kernel issues so if
> there is some additional information which would be useful let me know,
> I would be happy to provide it.  Just be sure to send instructions on
> how to gather it.
> 
> Thanks
> 
> Chris
> 

