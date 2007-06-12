Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXFLV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXFLV7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXFLV73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:59:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:45566 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXFLV73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:59:29 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can we get rid of zImage this time?
References: <466DE04C.4020303@zytor.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 12 Jun 2007 23:59:26 +0200
In-Reply-To: <466DE04C.4020303@zytor.com> (H. Peter Anvin's message of "Mon, 11 Jun 2007 16:52:44 -0700")
Message-ID: <m3ir9sygu9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Can we please kill zImage?  In addition to be completely useless for
> modern kernels, it causes unnecessary complexity in boot loaders.

I hope so.

BTW: I'd just kill old zImage and make it identical to bzImage
(I mean "make zImage" would now produce arch/i386/zImage identical
to arch/i386/bzImage made by "make bzImage").

Then we could use zImage as for other platforms.
-- 
Krzysztof Halasa
