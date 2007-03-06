Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXCFJFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXCFJFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXCFJFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:05:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51801 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXCFJFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:05:41 -0500
Message-ID: <45ED2EE1.4040505@garzik.org>
Date: Tue, 06 Mar 2007 04:05:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][libata] pata_pdc202xx_old: fix data corruption and other
 problems
References: <200703040158.43471.bzolnier@gmail.com> <200703040448.08578.bzolnier@gmail.com>
In-Reply-To: <200703040448.08578.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This version has improved patch description
> (on the second thought the original patch description was too vague).
> 
> Bart
> 
> [PATCH] pata_pdc202xx_old: fix possible data corruption and other problems

applied, though please include the "This version has improved patch 
description" notes after the "---" terminator.  That way, Linus's git 
tools automatically strip such meta-comments automatically from the 
patch description, before pasting directly into the kernel changelog.

	Jeff



