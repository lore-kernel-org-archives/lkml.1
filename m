Return-Path: <linux-kernel-owner+w=401wt.eu-S965520AbXA3Ohc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520AbXA3Ohc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXA3Ohb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:37:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46123 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965519AbXA3Oh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:37:29 -0500
Message-ID: <45BF5822.20607@garzik.org>
Date: Tue, 30 Jan 2007 09:37:22 -0500
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
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH 2.6.20-rc6 1/2] ehea: Fixed wrong jumbo frames status
 query
References: <200701291844.01887.osstklei@de.ibm.com>
In-Reply-To: <200701291844.01887.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> This patch fixes the wrong query and logging of the per interface jumbo frames
> enabled/disabled status.
> 
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

applied 1-2


