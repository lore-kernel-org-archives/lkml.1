Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXJQOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXJQOtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763155AbXJQOtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:49:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48947 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763486AbXJQOtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:49:03 -0400
Date: Wed, 17 Oct 2007 16:49:26 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apm system does not power off anymore
Message-ID: <20071017144926.GA6218@aepfle.de>
References: <20071012125426.GA16626@aepfle.de> <20071014232316.4beb160f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071014232316.4beb160f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, Andrew Morton wrote:

> On Fri, 12 Oct 2007 14:54:26 +0200 Olaf Hering <olaf@aepfle.de> wrote:
> 
> > Does anyone know what is required to power off an old PIII 400mhz
> > system? At some point (2.6.18 I think), apm=power-off was required with
> > an SMP kernel. Now with 2.6.22 and 2.6.23, even that does not work
> > anymore.
> 
> We break old machines at an unacceptably high (IMO) rate and then don't
> fix them.  Please, bisect it?

This will take a while.
The results differ with the used .configs, even with the same source tree.
Its not obvious from the .config diff what the cause is.
