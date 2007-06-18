Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbXFRTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbXFRTpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765566AbXFRTpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:45:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53017 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765549AbXFRTpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:45:17 -0400
Message-ID: <4676E0C3.9090909@garzik.org>
Date: Mon, 18 Jun 2007 15:45:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Divy Le Ray <divy@chelsio.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: cxgb3 regression in 2.6.22-rc5
References: <4676BB65.7070603@opengridcomputing.com>
In-Reply-To: <4676BB65.7070603@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> 
> I get this crash running the chelsio cxgb3 module on 2.6.22-rc5.  This 
> is regression.  I believe Divy from Chelsio has already posted a fix for 
> this.  This needs to be in 2.6.22...
> 
> Jeff do you have this fix queued for 2.6.22?
> 
> I think Divy's patches are here:
> 
> http://lkml.org/lkml/2007/5/30/291
> 
> and here:
> 
> http://lkml.org/lkml/2007/6/5/211


hmmm, no idea where these got to.  They are now in my queue, rescued.

	Jeff


