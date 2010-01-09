Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118Ab0AIMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0AIMiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061Ab0AIMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:38:17 -0500
Received: from isilmar.linta.de ([213.133.102.198]:37509 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754026Ab0AIMiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:38:16 -0500
Date: Sat, 9 Jan 2010 13:16:41 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, laforge@gnumonks.org
Subject: Re: [PATCH] cm4000_cs.c: Remove unnecessary cast
Message-ID: <20100109121641.GA4491@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, laforge@gnumonks.org
References: <201001081130.13177.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001081130.13177.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jan 08, 2010 at 11:30:13AM -0700, H Hartley Sweeten wrote:
> cm4000_cs.c: Remove unnecessary cast
> 
> The struct file 'private_data' member is a void *, the cast is not needed.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Harald Welte <laforge@gnumonks.org>

Applied to linux-pcmcia, in queue for 2.6.34-rc1.

Thanks,
	Dominik
