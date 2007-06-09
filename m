Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbXFIW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbXFIW0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXFIW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 18:26:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35174 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbXFIW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 18:26:36 -0400
Message-ID: <466B2918.9070400@garzik.org>
Date: Sat, 09 Jun 2007 18:26:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH 2.6.22-rc4] ehea: Fixed possible kernel panic on VLAN
 packet recv
References: <200706062053.16986.osstklei@de.ibm.com>
In-Reply-To: <200706062053.16986.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> This patch fixes a possible kernel panic due to not checking the vlan group
> when processing received VLAN packets and a malfunction in VLAN/hypervisor
> registration.
> 
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

applied


