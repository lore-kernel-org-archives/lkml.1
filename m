Return-Path: <linux-kernel-owner+w=401wt.eu-S1422953AbXDXSBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbXDXSBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXDXSBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:01:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40317 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422955AbXDXSBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:01:48 -0400
Message-ID: <462E4605.7070706@garzik.org>
Date: Tue, 24 Apr 2007 14:01:41 -0400
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
Subject: Re: [PATCH] ehea: fix for dlpar and sysfs entries
References: <200704051122.28428.ossthema@de.ibm.com>
In-Reply-To: <200704051122.28428.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch includes:
> - dlpar fix: 
> 	certain resources may only be allocated when first
> 	logical port is available, and must be removed when
> 	last logical port has been removed
> 
> - sysfs entries:
> 	create symbolic link from each logical port to ehea driver
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

What Arnd said... this should be two patches


