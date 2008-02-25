Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYBYXG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYBYXG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYBYXGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:06:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:52890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752459AbYBYXGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:06:48 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19hJ4VVHeZh827+LXVDkvUypOpAGN+mLUdh+kWsra
	wAXF/7erlJmOik
Date: Tue, 26 Feb 2008 00:06:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Tim Ellis <tim@ngndg.com>, benh@kernel.crashing.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
In-Reply-To: <47C347C3.40404@garzik.org>
Message-ID: <Pine.LNX.4.64.0802260004570.19416@axis700.grange>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
 <1202850129.7410.22.camel@pasglop> <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
 <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop>
 <DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com> <47C347C3.40404@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Jeff Garzik wrote:

> But if its broken its broken, and we need to revert.  Any luck getting benh
> access to the device?

We're working on it... We've got devices, but they have to be recovered 
with jtag first, which requires some soldering... I was told this should 
happen end of this / beginning of the next week.

Thanks
Guennadi
---
Guennadi Liakhovetski
