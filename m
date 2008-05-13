Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYEMFP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYEMFP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYEMFPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:15:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49314 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbYEMFPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:15:06 -0400
Message-ID: <482923D3.8060100@garzik.org>
Date: Tue, 13 May 2008 01:14:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, csnook@redhat.com,
       pelle@dsv.su.se
Subject: Re: [PATCH 1/4] atl1: add PHY power save mode
References: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net> <1210389129-3868-2-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1210389129-3868-2-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Using vendor-provided magic, add code to enter power save mode
> on the PHY.  We'll need this for suspend and wake-on-lan.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |   19 ++++++++-----------
>  drivers/net/atlx/atlx.h |    3 +++
>  2 files changed, 11 insertions(+), 11 deletions(-)

applied 1-4


