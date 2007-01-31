Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXAaFug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXAaFug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXAaFug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:50:36 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51258 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXAaFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:50:35 -0500
Date: Tue, 30 Jan 2007 21:50:24 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] AGPGART compat ioctl
In-reply-to: <20070131030340.GB7088@athena.road.mcmartin.ca>
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0701302147120.28531@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
 <20070131030340.GB7088@athena.road.mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Kyle McMartin wrote:

> On Sat, Jan 27, 2007 at 07:28:07PM -0800, Zwane Mwaikambo wrote:
> > Hi Dave,
> > 	The following video card requires the agpgart driver ioctl 
> > interface in order to detect video memory.
> > 
> 
> Tested with testgart.c on parisc64, seems to work alright. Thanks for
> doing this work, Zwane. I've been meaning to do compat_ioctl for
> agpgart for months.

Kyle,
	Thanks for testing! Hopefully Dave can just queue it up for me.

Cheers,
	Zwane
