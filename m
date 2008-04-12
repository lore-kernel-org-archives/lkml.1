Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYDLJDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYDLJDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758859AbYDLJCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:02:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59425 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbYDLJCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:02:54 -0400
Message-ID: <48007ABA.7030705@pobox.com>
Date: Sat, 12 Apr 2008 05:02:50 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Dhananjay Phadke <dhananjay@netxen.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make netxen_workq static
References: <20080330232218.GP28445@cs181133002.pp.htv.fi>
In-Reply-To: <20080330232218.GP28445@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> netxen_workq can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/net/netxen/netxen_nic.h      |   17 -----------------
>  drivers/net/netxen/netxen_nic_main.c |   20 +++++++++++++++++++-
>  2 files changed, 19 insertions(+), 18 deletions(-)

applied this and the other netxen cleanup


