Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXCWF7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXCWF7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbXCWF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:59:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60597 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbXCWF7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:59:03 -0400
Message-ID: <46036CA3.1050304@garzik.org>
Date: Fri, 23 Mar 2007 01:58:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/2] ehea: fix for dynamic lpar support
References: <200703221749.42876.ossthema@de.ibm.com>
In-Reply-To: <200703221749.42876.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> The patch fixes bugs related to the probe / remove adapter
> functionality (handling of OFDT nodes)
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied 1-2


