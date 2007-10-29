Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXJ2Ne6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXJ2Ne6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJ2Nev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:34:51 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41399 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXJ2Neu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:34:50 -0400
Date: Mon, 29 Oct 2007 09:31:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: dhowells@redhat.com
Subject: Re: [PATCH] FRV:  Move DMA macros to scatterlist.h for consistency.
In-Reply-To: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0710290931110.12142@localhost.localdomain>
References: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Robert P. J. Day wrote:

>
> To be consistent with other architectures, these two DMA macros should
> be defined in scatterlist.h as opposed to dma-mapping.h
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

whoops, just noticed that i hadn't updated my sig to reflect my new
"crashcourse.ca" domain name.  not a big deal, but if someone wants to
tweak that before applying, i wouldn't object.  sorry.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
