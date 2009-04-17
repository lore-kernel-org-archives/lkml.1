Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZDQTqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZDQTqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDQTp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:45:57 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56764 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZDQTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:45:56 -0400
Date: Fri, 17 Apr 2009 15:45:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: include/linux/compiler-gcc[34].h no longer referenced?
In-Reply-To: <m28wlzw1kw.fsf@igel.home>
Message-ID: <alpine.LFD.2.00.0904171544280.20046@localhost.localdomain>
References: <alpine.LFD.2.00.0904171120490.16701@localhost.localdomain> <m28wlzw1kw.fsf@igel.home>
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

On Fri, 17 Apr 2009, Andreas Schwab wrote:

> "Robert P. J. Day" <rpjday@crashcourse.ca> writes:
>
> >   from my latest cleanup script run on the current source, it would
> > appear that neither of those two header files are being included
> > anymore.
>
> See the last line of include/linux/compiler-gcc.h.

  yes, my bad, my scanning script looked for literal includes and
missed the macro concatenation.  sorry.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
