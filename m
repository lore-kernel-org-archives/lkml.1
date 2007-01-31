Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbXAaUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbXAaUSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbXAaUSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:18:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348AbXAaUSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:18:32 -0500
Date: Wed, 31 Jan 2007 15:15:28 -0500
From: Dave Jones <davej@redhat.com>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AGPGART compat ioctl
Message-ID: <20070131201528.GD6186@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Zwane Mwaikambo <zwane@infradead.org>,
	Kyle McMartin <kyle@parisc-linux.org>,
	Andrew Morton <akpm@osdl.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com> <20070131030340.GB7088@athena.road.mcmartin.ca> <Pine.LNX.4.64.0701302147120.28531@montezuma.fsmlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701302147120.28531@montezuma.fsmlabs.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:50:24PM -0800, Zwane Mwaikambo wrote:
 > On Tue, 30 Jan 2007, Kyle McMartin wrote:
 > 
 > > On Sat, Jan 27, 2007 at 07:28:07PM -0800, Zwane Mwaikambo wrote:
 > > > Hi Dave,
 > > > 	The following video card requires the agpgart driver ioctl 
 > > > interface in order to detect video memory.
 > > > 
 > > 
 > > Tested with testgart.c on parisc64, seems to work alright. Thanks for
 > > doing this work, Zwane. I've been meaning to do compat_ioctl for
 > > agpgart for months.
 > 
 > Kyle,
 > 	Thanks for testing! Hopefully Dave can just queue it up for me.

Looks ok, I'll queue it up into agpgart.git tonight for merging in 2.6.21
(whilst it's unlikely to break anything, .20 is really dragging on a bit)

Thanks.

		Dave

-- 
http://www.codemonkey.org.uk
