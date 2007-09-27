Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXI0D7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXI0D7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 23:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbXI0D6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 23:58:50 -0400
Received: from mail-gw17.credit-suisse.com ([198.240.130.182]:36732 "EHLO
	nys17a-3002.corpny.csfb.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751657AbXI0D6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 23:58:49 -0400
X-Server-Uuid: 4EAC7D12-E00D-46D7-91F2-2C1B0FAC6618
X-Server-Uuid: 08F52AA2-166F-476D-B0A0-AD41BF62CDCC
Message-ID: <F444CAE5E62A714C9F45AA292785BED3223F7283@esng11p33001.sg.csfb.com>
From: "Majumder, Rajib" <rajib.majumder@credit-suisse.com>
To: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: TCP Spike
Date: Thu, 27 Sep 2007 11:58:01 +0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2655.55)
X-WSS-ID: 6AE5F5C52I01951142-01-01
X-WSS-ID: 6AE5F5D43WO54487-01-05
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have observed 40ms latency spikes in TCP connections in "burst" type of traffic. This affects regular TCP sockets. We observed this issue in kernels of 2.4.21 and kernel 2.6.5.  

Aparently, this seems to be fixed in 2.6.19.  

Can someone throw some light on this? 

Is this a congestion control/avoidance issue? What congestion control algorithm is used before 2.6.8?   

Thanks

Rajib



==============================================================================
Please access the attached hyperlink for an important electronic communications disclaimer: 

http://www.credit-suisse.com/legal/en/disclaimer_email_ib.html
==============================================================================

