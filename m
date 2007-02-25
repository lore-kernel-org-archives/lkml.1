Return-Path: <linux-kernel-owner+w=401wt.eu-S965187AbXBYWjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbXBYWjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965185AbXBYWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:39:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35372 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbXBYWjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:39:09 -0500
Message-ID: <45E21009.6040706@garzik.org>
Date: Sun, 25 Feb 2007 17:39:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] cxgb3 - FW version update
References: <20070225004401.20831.3292.stgit@localhost.localdomain>	 <1172431719.4717.8.camel@stevo-laptop>  <45E1E810.2000706@garzik.org> <1172440758.4717.17.camel@stevo-laptop>
In-Reply-To: <1172440758.4717.17.camel@stevo-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
>> I would rather fix the code to use constants, and thus avoid this 
>> problem ever happening again.
>>
>> 	Jeff
>>
> 
> How's this (not tested)?

seems OK to me


