Return-Path: <linux-kernel-owner+w=401wt.eu-S940479AbXGSR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940479AbXGSR6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXGSR6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:58:07 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:39049 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbXGSR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:58:06 -0400
Subject: Re: [PATCH] [scsi] lpfc: potential leak in
	lpfc_sli_hbqbuf_fill_hbqs
From: James Bottomley <James.Bottomley@SteelEye.com>
To: James.Smart@Emulex.Com
Cc: Florin Malita <fmalita@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <469FA312.7070702@emulex.com>
References: <469F884B.6010402@gmail.com>  <469FA312.7070702@emulex.com>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 12:58:03 -0500
Message-Id: <1184867884.3464.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 13:44 -0400, James Smart wrote:
> Florin,
> 
> Thanks for the effort to create this patch.  Turns out we have already
> fixed this, and have it included in our 8.2.2 patch set, which we will be
> posting within the next week.

The 2.6.23 merge window is estimated to close on Sunday (22 July) ...

> So James, don't pick this patch up, take the larger patch set instead.

OK, will wait.

James


