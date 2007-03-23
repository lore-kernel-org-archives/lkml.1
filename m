Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXCWFuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXCWFuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXCWFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:50:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60447 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXCWFuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:50:04 -0400
Message-ID: <46036A8A.2050606@garzik.org>
Date: Fri, 23 Mar 2007 01:50:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 1/4] cxgb3 - fix ethtool cmd on multiple queues
 port
References: <20070318201001.16269.86377.stgit@localhost.localdomain>
In-Reply-To: <20070318201001.16269.86377.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Limit ethtool -g/-G to the given port's queues.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

applied 1-4


