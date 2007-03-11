Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXCKAng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXCKAng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXCKAnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:43:35 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:46894 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751564AbXCKAnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:43:35 -0500
Subject: Re: [PATCH] SCSI: Delete unused header file.
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0703101715050.28707@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703101715050.28707@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 18:43:31 -0600
Message-Id: <1173573812.4416.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 17:16 -0500, Robert P. J. Day wrote:
>   Delete apparently unused header file drivers/scsi/pci2000.h.

This was apparently missed by Christoph when he removed the driver ...
I'll add it to the queue.  For future SCSI work, could you cc
linux-scsi@vger.kernel.org please?  That way, any interested parties are
more likely to see the patch.

Thanks,

James

