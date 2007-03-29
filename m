Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXC2MfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXC2MfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXC2MfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:35:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52597 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXC2MfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:35:14 -0400
Message-ID: <460BB27C.4070006@garzik.org>
Date: Thu, 29 Mar 2007 08:35:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ehea: removing unused functionality
References: <200703231718.53668.ossthema@de.ibm.com>
In-Reply-To: <200703231718.53668.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch includes:
> - removal of unused fields in structs
> - ethtool statistics cleanup
> - removes unsed functionality from send path
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> ---
> 
> 
> This patch applies on top of the netdev upstream branch for 2.6.22
> 
> 
>  drivers/net/ehea/ehea.h         |   25 ++-------
>  drivers/net/ehea/ehea_ethtool.c |  111 ++++++++++++++--------------------------
>  drivers/net/ehea/ehea_main.c    |   55 +++++++------------
>  drivers/net/ehea/ehea_qmr.h     |    2
>  4 files changed, 69 insertions(+), 124 deletions(-)
> 

applied to #upstream


