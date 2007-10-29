Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbXJ2Npu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbXJ2Npu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXJ2Npm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:45:42 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:42816 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXJ2Npl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:45:41 -0400
Date: Mon, 29 Oct 2007 09:42:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FRV: Move DMA macros to scatterlist.h for consistency.
In-Reply-To: <10838.1193665233@redhat.com>
Message-ID: <Pine.LNX.4.64.0710290941550.12714@localhost.localdomain>
References: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
 <10838.1193665233@redhat.com>
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

On Mon, 29 Oct 2007, David Howells wrote:

> Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
> > To be consistent with other architectures, these two DMA macros should
> > be defined in scatterlist.h as opposed to dma-mapping.h
>
> Why have you discarded the comment?
>
> David

whoops, my mistake.  i'll resubmit and put it back in.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
