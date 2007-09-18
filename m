Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbXIRWHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbXIRWHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXIRWHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:07:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52556 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXIRWHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:07:43 -0400
Message-ID: <46F04C2A.20500@garzik.org>
Date: Tue, 18 Sep 2007 18:07:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/3] Blackfin EMAC driver: add function to change the
 MAC	address
References: <1189911423.9901.4.camel@roc-laptop>
In-Reply-To: <1189911423.9901.4.camel@roc-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
>>From 157dfddae50708a716c2a42a314eccb9621d8793 Mon Sep 17 00:00:00 2001
> From: Alex Landau <lirsb@yahoo.com>
> Date: Sun, 5 Aug 2007 15:58:03 +0800
> Subject: [PATCH] Blackfin Ethernet MAC driver: add function to change the MAC address
> 
> Alex Landau writes in the forums:
>   Previously, changing the MAC address (e.g. via ifconfig) resulted
>   in a generic function to be called that only changed a variable in
>   memory. This patch also updated the Blackfin MAC address registers
>   to filter the correct new MAC.
> 
> Signed-off-by: Alex Landau <lirsb@yahoo.com>
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

ACK patches 1-3... but can you regenerate them against 
netdev-2.6.git#upstream (or davem/net-2.6.24.git)?


