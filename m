Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYFRD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYFRD0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYFRD0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:26:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40542 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbYFRD0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:26:19 -0400
Message-ID: <48588056.2000605@garzik.org>
Date: Tue, 17 Jun 2008 23:26:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: netdev@vger.kernel.org, Claudio Lanconelli <lanconelli.claudio@eptar.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND #4/patch 2.6.26-rc6] net/enc28j60: section fix
References: <200806122136.24921.david-b@pacbell.net>
In-Reply-To: <200806122136.24921.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Minor bugfixes to the enc28j60 driver ... wrong section marking,
> indentation, and bogus use of spi_bus_type.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Acked-by: Claudio Lanconelli <lanconelli.claudio@eptar.com>
> ---
> Previously sent:  18-April, 19-February, 6-February.
> 
>  drivers/net/enc28j60.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

applied


