Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbXD1AOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbXD1AOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbXD1AOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:14:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48218 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbXD1AOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:14:03 -0400
Message-ID: <463291C3.2020901@garzik.org>
Date: Fri, 27 Apr 2007 20:13:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ehea: fix for sysfs entries
References: <200704261156.13487.osstklei@de.ibm.com>
In-Reply-To: <200704261156.13487.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Create symbolic link from each logical port to ehea driver
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> 
> 
> This patch applies on top of the netdev upstream branch for 2.6.22

applied 1-2


