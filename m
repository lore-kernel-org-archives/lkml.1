Return-Path: <linux-kernel-owner+w=401wt.eu-S965473AbXBFVFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbXBFVFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXBFVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:05:48 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54496 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965473AbXBFVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:05:47 -0500
Message-ID: <45C8EDA7.2090303@garzik.org>
Date: Tue, 06 Feb 2007 16:05:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Robert Hancock <hancockr@shaw.ca>, Stephen.Clark@seclark.us,
       Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us> <45C51A80.3050308@shaw.ca> <45C8BE89.9000705@tmr.com>
In-Reply-To: <45C8BE89.9000705@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I think deciding to turn off DMA which works fine in old kernels 
> qualifies as a "serious driver problem," which is why it should be under 
> user control.

For PATA, perhaps.

For SATA, turning off DMA can often -cause- additional problems.

	Jeff


