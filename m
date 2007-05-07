Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXEGBEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXEGBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXEGBEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:04:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41747 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXEGBEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:04:15 -0400
Message-ID: <463E7B0C.50502@garzik.org>
Date: Sun, 06 May 2007 21:04:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andries.Brouwer@cwi.nl
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: regressions
References: <200705062049.l46KnD424997@apps.cwi.nl>
In-Reply-To: <200705062049.l46KnD424997@apps.cwi.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andries.Brouwer@cwi.nl wrote:
> 2.6.21 breaks HPT366 - back to 2.6.20

I thought Bart/Sergei had fixed this.  Are you using libata or old-IDE 
driver?


> 2.6.20 breaks ZIP - back to 2.6.19

What does this mean?  How is it broken?

	Jeff


