Return-Path: <linux-kernel-owner+w=401wt.eu-S936539AbXHGV5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936539AbXHGV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936546AbXHGVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:34:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60856 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935814AbXHGVej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:34:39 -0400
Message-ID: <46B8E56A.104@garzik.org>
Date: Tue, 07 Aug 2007 17:34:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH 1/3] ehea: Fix workqueue handling
References: <200708061354.30653.osstklei@de.ibm.com>
In-Reply-To: <200708061354.30653.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Fix: Workqueue ehea_driver_wq was not destroyed
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
>  drivers/net/ehea/ehea.h      |    2 +-
>  drivers/net/ehea/ehea_main.c |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)

applied 1-3 to #upstream-fixes


