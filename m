Return-Path: <linux-kernel-owner+w=401wt.eu-S1031301AbXEASmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031301AbXEASmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031300AbXEASmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:42:14 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43830 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031298AbXEASmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:42:13 -0400
Subject: Re: [PATCH] drivers/scsi/pci2000.h: Remove unused file
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, ballabio_dario@emc.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705011415070.13459@localhost.localdomain>
References: <20070501180113.20160.77978.sendpatchset@thinktank.campus.ltu.se>
	 <Pine.LNX.4.64.0705011415070.13459@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 01 May 2007 13:42:04 -0500
Message-Id: <1178044924.4320.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 14:16 -0400, Robert P. J. Day wrote:
> On Tue, 1 May 2007, Richard Knutsson wrote:
> 
> > Remove the unused header drivers/scsi/pci2000.h
> 
> i have the same patch in my pending patch directory, dated march 10,
> so i know i submitted it, but i have no idea whatever happened to it.

It's in -mm via this, pending merge with linus:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=38891cb6b0de3f5986e6a7688c5ae17c18b000a9

James


