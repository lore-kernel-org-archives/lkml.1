Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbXE3OAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbXE3OAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXE3OAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:00:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33931 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbXE3OAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:00:33 -0400
Message-ID: <465D8379.3090109@garzik.org>
Date: Wed, 30 May 2007 10:00:25 -0400
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
Subject: Re: [PATCH 2.6.22-rc3] ehea: Fixed multi queue RX bug
References: <200705301239.23934.osstklei@de.ibm.com>
In-Reply-To: <200705301239.23934.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Must access the respective queue's dummy netdev instead of the port's netdev.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

applied


