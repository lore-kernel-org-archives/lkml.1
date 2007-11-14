Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbXKNPjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbXKNPjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXKNPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:38:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:34414 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754283AbXKNPiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:38:52 -0500
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX1+67SdccW+6aVaMO1SWB1PkQh+ZDC7sFcMRwtGDS8
	Q439UJ1zXXKcDj
Date: Wed, 14 Nov 2007 16:38:52 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Mark Lord <liml@rtr.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071114153852.GA9019@section-eight>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B0FA2.5000102@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B0FA2.5000102@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:09:22AM -0500, Mark Lord wrote:
> I think the problem here might be that libata doesn't actually support 
> SG_IO
> for ATAPI drives prior to 2.6.24 (ugh).
>
> Try it with a 2.6.24-rc* kernel from kernel.org, or back-patch the ATA_16
> SG_IO support into your older kernel.

Hi Mark,

I already tried 2.6.24-rc2 and it didn't work, see my last reply:
http://marc.info/?l=linux-kernel&m=119504244805467&w=2

Regards
Sebastian
