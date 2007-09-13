Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbXIMEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbXIMEOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXIMEOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:14:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXIMEOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:14:09 -0400
Message-ID: <46E8B909.2050201@garzik.org>
Date: Thu, 13 Sep 2007 00:14:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/2][RESEND] ehea: propagate physical port state
References: <200709071230.18395.ossthema@de.ibm.com>
In-Reply-To: <200709071230.18395.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Introduces a module parameter to decide whether the physical
> port link state is propagated to the network stack or not.
> It makes sense not to take the physical port state into account
> on machines with more logical partitions that communicate
> with each other. This is always possible no matter what the physical
> port state is. Thus eHEA can be considered as a switch there.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied 1-2


