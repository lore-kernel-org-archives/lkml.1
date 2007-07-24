Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbXGXUib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbXGXUib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbXGXUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:37:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbXGXUhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:37:36 -0400
Message-ID: <46A6630C.9010502@garzik.org>
Date: Tue, 24 Jul 2007 16:37:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] eHEA: net_poll support
References: <200707231605.03459.ossthema@de.ibm.com>
In-Reply-To: <200707231605.03459.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> net_poll support for eHEA added
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> ---
> 
> 
>  drivers/net/ehea/ehea.h      |    2 +-
>  drivers/net/ehea/ehea_main.c |   22 +++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 2 deletions(-)

applied


