Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYDLIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYDLIuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYDLIuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:50:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41445 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbYDLIuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:50:00 -0400
Message-ID: <480077B1.3010804@garzik.org>
Date: Sat, 12 Apr 2008 04:49:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hannes Hering <hering2@de.ibm.com>
Subject: Re: [PATCH] ehea: Fix DLPAR memory add support
References: <200804041504.54130.osstklei@de.ibm.com>
In-Reply-To: <200804041504.54130.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> This patch fixes two weaknesses in send/receive packet handling which may
> lead to kernel panics during DLPAR memory add operations.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

applied


