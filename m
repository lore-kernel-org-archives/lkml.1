Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXKCMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXKCMfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXKCMew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:34:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40340 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXKCMev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:34:51 -0400
Message-ID: <472C6AE1.30104@garzik.org>
Date: Sat, 03 Nov 2007 08:34:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Daniel Drake <dsd@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org> <4729F8F1.4040103@gmail.com> <472B946F.4030004@gentoo.org> <472BCC18.7070503@gmail.com>
In-Reply-To: <472BCC18.7070503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Does this patch fix the problem?
[snip]

I hope it does...  that patch removes a call to sg_last() and in general 
cleans up the function a bit, which is nice.

	Jeff




