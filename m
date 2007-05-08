Return-Path: <linux-kernel-owner+w=401wt.eu-S967925AbXEHFRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967925AbXEHFRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967920AbXEHFRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:17:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54359 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967918AbXEHFRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:17:44 -0400
Message-ID: <464007F4.4060608@garzik.org>
Date: Tue, 08 May 2007 01:17:40 -0400
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
Subject: Re: [PATCH] ehea: Fix skb header access
References: <200705021607.05338.osstklei@de.ibm.com>
In-Reply-To: <200705021607.05338.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Adapt to new skb header access functions.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

applied


