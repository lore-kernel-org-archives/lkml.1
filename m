Return-Path: <linux-kernel-owner+w=401wt.eu-S966293AbXDDCbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966293AbXDDCbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966292AbXDDCbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:31:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40237 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966268AbXDDCbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:31:34 -0400
Message-ID: <46130E02.3020806@garzik.org>
Date: Tue, 03 Apr 2007 22:31:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 1/4] cxgb3 - Safeguard TCAM size usage
References: <20070331072313.4694.92549.stgit@localhost.localdomain>
In-Reply-To: <20070331072313.4694.92549.stgit@localhost.localdomain>
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
> Ensure that the TCAM active region size is at least 16.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/common.h        |    3 +++
>  drivers/net/cxgb3/cxgb3_main.c    |    7 +++++--
>  drivers/net/cxgb3/cxgb3_offload.c |    4 +++-
>  3 files changed, 11 insertions(+), 3 deletions(-)

applied 1-4


