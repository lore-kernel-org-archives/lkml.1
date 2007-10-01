Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXJAOoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXJAOoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXJAOop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:44:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34826 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJAOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:44:43 -0400
Message-ID: <470107D9.2040301@garzik.org>
Date: Mon, 01 Oct 2007 10:44:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ehea: DLPAR memory add fix
References: <200710011633.18305.ossthema@de.ibm.com>
In-Reply-To: <200710011633.18305.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Due to stability issues in high load situations the HW queue handling
> has to be changed. The HW queues are now stopped and restarted again instead
> of destroying and allocating new HW queues. 
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

May I presume this is for 2.6.23?

	Jeff



