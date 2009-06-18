Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZFRJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZFRJaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZFRJaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:30:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36421 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZFRJaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:30:06 -0400
Date: Thu, 18 Jun 2009 11:23:09 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [patch 1/2] crypto: padlock-aes: work around Nano CPU errata
	in ECB mode
Message-ID: <20090618092309.GT7692@prithivi.gnumonks.org>
References: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

do you think we will still be able to get this Nano errata handling
into 2.6.31?  I've noticed that crpyto-2.6 and cryptodev-2.6 also don't seem
to have those patches.  Are there any issues?  I would want to help in case
there is any to-be-resolved issues with this patchset.

Once we have it in mainline, I woul also ask about your opinion on whether
you think they're applicable for the -stable series.

Thanks in advance,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
