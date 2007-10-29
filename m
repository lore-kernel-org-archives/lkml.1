Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXJ2Jrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXJ2Jrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXJ2Jrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:47:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbXJ2Jrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:47:40 -0400
Message-ID: <4725AC37.2050903@garzik.org>
Date: Mon, 29 Oct 2007 05:47:35 -0400
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
Subject: Re: [PATCH] ehea: add kexec support
References: <200710261437.29117.ossthema@de.ibm.com>
In-Reply-To: <200710261437.29117.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> eHEA resources that are allocated via H_CALLs have a unique identifier each.
> These identifiers are necessary to free the resources. A reboot notifier
> is used to free all eHEA resources before the indentifiers get lost, i.e
> before kexec starts a new kernel.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied to #upstream-fixes


