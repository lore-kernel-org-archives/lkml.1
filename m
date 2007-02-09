Return-Path: <linux-kernel-owner+w=401wt.eu-S1946030AbXBIVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946030AbXBIVLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945935AbXBIVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:11:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60275 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423266AbXBIVLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:11:07 -0500
Message-ID: <45CCE365.4070502@garzik.org>
Date: Fri, 09 Feb 2007 16:11:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2.6.21-rc1] ehea: Fixed error recovery
References: <200702090910.51646.ossthema@de.ibm.com>
In-Reply-To: <200702090910.51646.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Error recovery for QP errors: Reset QPs and dump error information
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied


