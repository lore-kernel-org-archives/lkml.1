Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXCPP6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXCPP6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXCPP6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:58:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59778 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXCPP6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:58:23 -0400
Message-ID: <45FABE9D.6070600@garzik.org>
Date: Fri, 16 Mar 2007 11:58:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Charles Shannon Hendrix <shannon@widomaker.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SATA problems in 2.6.20.3
References: <20070316113657.161e5315@daydream.goid.lan>
In-Reply-To: <20070316113657.161e5315@daydream.goid.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> I normally run a modified 2.6.19 kernel and it works great.
> 
> I recently tried 2.6.20 and had severe SATA problems with it.
> 
> Yesterday I tried 2.6.20.3, and the problems are still there.

Setting the module parameter 'adma' to zero fixes this, yes?

	Jeff



