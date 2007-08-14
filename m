Return-Path: <linux-kernel-owner+w=401wt.eu-S942796AbXHNFqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942796AbXHNFqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942226AbXHNFog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:44:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46754 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942192AbXHNFoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:44:34 -0400
Message-ID: <46C14140.2000104@garzik.org>
Date: Tue, 14 Aug 2007 01:44:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 5/13] cxgb3 - Expose HW memory page info
References: <20070811062954.8094.33064.stgit@speedy5>
In-Reply-To: <20070811062954.8094.33064.stgit@speedy5>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Let the RDMA driver get HW page info to work around HW issues.
> Assign explicit enum values.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

"HW issues" -- you need to go into far more detail, when adding a new 
interface.  what hw issues?  why was this the best/only solution?


