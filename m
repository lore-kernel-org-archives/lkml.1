Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXEVAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXEVAC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbXEVACs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:02:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbXEVACr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:02:47 -0400
Message-ID: <46523323.20304@garzik.org>
Date: Mon, 21 May 2007 20:02:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: Add Seagate STT20000A to DMA blacklist.
References: <fa.6aGWKqGWP2vDWJvVhFqggIUaWVk@ifi.uio.no> <fa.70JldrzRTUl84Jt2lSquANqNr2Q@ifi.uio.no> <fa.xozW+S/WBbGA8Gv2z3FmAe/XymA@ifi.uio.no> <4651E2AF.2080109@shaw.ca> <20070521183102.GA14537@redhat.com>
In-Reply-To: <20070521183102.GA14537@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=1044 points out an
> additional hard disk that doesn't handle DMA transfers correctly.
> This patch is the libata variant of the earlier patch to drivers/ide/
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

applied


