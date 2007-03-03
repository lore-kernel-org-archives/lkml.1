Return-Path: <linux-kernel-owner+w=401wt.eu-S2992844AbXCCBGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992844AbXCCBGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992842AbXCCBGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:06:25 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55443 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992840AbXCCBGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:06:24 -0500
Message-ID: <45E8CA09.9030104@garzik.org>
Date: Fri, 02 Mar 2007 20:06:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/2] ehea: dynamic add / remove port
References: <200702281834.02990.ossthema@de.ibm.com>
In-Reply-To: <200702281834.02990.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch introduces functionality to dynamically add / remove
> ehea ports via an userspace DLPAR tool. It creates a subnode for
> each logical port in the sysfs. 
> 
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied 1-2 to #upstream (2.6.22)

your patches added much trailing whitespace.  please fix.


