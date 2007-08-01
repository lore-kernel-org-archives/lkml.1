Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbXHAQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbXHAQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXHAQLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:11:25 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37985 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbXHAQLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:11:24 -0400
Subject: Re: [PATCH 82] drivers/scsi/zorro7xx.c: kmalloc + memset
	conversion to kzalloc
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
In-Reply-To: <200708010021.34147.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200708010021.34147.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:11:21 -0500
Message-Id: <1185984681.3468.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 00:21 +0200, Mariusz Kozlowski wrote:
> [PATCH 82] ...

Please no.  This should be a simple mechanical substitution.  I don't
need to collect acks from everyone.  This is a nice point to do a
conversion like this, so I'll sort out the mismerges.

Please assure me you have a good methodology for doing the replacement
and a reasonable one for testing and then send either one patch for the
entirety of SCSI to me, or one patch for the entirety of the kernel to
Andrew and we'll see if we can get it through the process.

James


