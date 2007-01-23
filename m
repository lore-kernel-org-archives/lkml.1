Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbXAWF7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbXAWF7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbXAWF7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:59:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45504 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbXAWF7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:59:48 -0500
Message-ID: <45B5A44E.9020703@garzik.org>
Date: Tue, 23 Jan 2007 00:59:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <roscher@de.ibm.com>,
       Stefan Roscher <ossrosch@de.ibm.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2.6.20-rc5 1/7] ehea: Fixed wrong dereferencation
References: <200701221252.20814.osstklei@de.ibm.com>
In-Reply-To: <200701221252.20814.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Not only check the pointer against 0 but also the dereferenced value
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> 
> 
>  drivers/net/ehea/ehea.h      |    2 +-
>  drivers/net/ehea/ehea_main.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

applied 1-7 to #upstream-fixes

