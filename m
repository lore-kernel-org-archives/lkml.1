Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbYBMJ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbYBMJ1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932805AbYBMJ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:26:51 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:36873 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbYBMJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:26:48 -0500
Date: Wed, 13 Feb 2008 04:26:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest list of unused Kconfig variables
In-Reply-To: <20080213092038.GA16692@linux-sh.org>
Message-ID: <alpine.LFD.1.00.0802130426240.32188@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213092038.GA16692@linux-sh.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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

On Wed, 13 Feb 2008, Paul Mundt wrote:

> On Wed, Feb 13, 2008 at 03:56:34AM -0500, Robert P. J. Day wrote:
> >   latest output here, sorted by architecture:
> >
> > http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> >
> > as always, there will probably be some false positives for one reason
> > or another.
> >
>
> >>>>> SH_SDK7780_STANDALONE
> arch/sh/boards/renesas/sdk7780/Kconfig:7:config SH_SDK7780_STANDALONE
>
> is taken care of, thanks.

ok, i tossed it from the list.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
