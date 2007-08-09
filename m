Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXHIRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXHIRw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXHIRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:52:49 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45843 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXHIRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:52:49 -0400
Date: Thu, 9 Aug 2007 19:53:07 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include linux/types.h in if_fddi.h
Message-ID: <20070809175307.GA10114@aepfle.de>
References: <20070809145511.GA8244@aepfle.de> <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl> <20070809173835.GA10094@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809173835.GA10094@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, Olaf Hering wrote:

> Please drop the patch.

glibc includes asm/types.h, not linux/types.h. So changing the package
to netinet/if_fddi.h does not fix anything.

Please dont drop it.
Or should all glibc includes be changed from asm/types.h to linux/types.h?

