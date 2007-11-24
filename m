Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXKXDKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXKXDKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXKXDKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:10:04 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44343 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbXKXDKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:10:02 -0500
Message-ID: <47479606.10004@garzik.org>
Date: Fri, 23 Nov 2007 22:09:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/2][2.6.24] ehea: Improve tx packets counting
References: <200711211737.58789.osstklei@de.ibm.com>
In-Reply-To: <200711211737.58789.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Using own tx_packets counter instead of firmware counters.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
>  drivers/net/ehea/ehea.h      |    2 +-
>  drivers/net/ehea/ehea_main.c |    9 +++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)

applies 1-2 to #upstream-fixes


