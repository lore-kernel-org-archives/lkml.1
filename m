Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXKNRQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXKNRQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXKNRQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:16:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:34084 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756910AbXKNRQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:16:28 -0500
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX1/3HUZg0Rv3paWrikT/iKgrWEfTvGGCcs1bqR2rgG
	rD7S6sN10kvzc2
Date: Wed, 14 Nov 2007 18:16:18 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Mark Lord <liml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071114171618.GB9387@section-eight>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B219E.5060508@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B219E.5060508@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:26:06AM -0500, Mark Lord wrote:
> Another way to the same thing is with "hdparm -E",
> which contrary to my earlier posting actually does
> seem to work already with libata.

Hi!

There are DVD-ROM drives that don't react to hdparm -E but do react to
SET_STREAMING, for instance some NEC drives.

Regards
Sebastian
