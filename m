Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbXGJRAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbXGJRAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbXGJQ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:59:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60398 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbXGJQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:59:56 -0400
Message-ID: <4693BB07.9060707@garzik.org>
Date: Tue, 10 Jul 2007 12:59:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/2] eHEA: Capability flag for DLPAR support
References: <200707050926.26087.ossthema@de.ibm.com>
In-Reply-To: <200707050926.26087.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch introduces a capability flag that is used by the DLPAR userspace
> tool to check which DLPAR features are supported by the eHEA driver.
> 
> Missing goto has been included.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied


