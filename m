Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXJYHc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXJYHc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXJYHb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:31:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58950 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035AbXJYHb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:31:56 -0400
Message-ID: <47204667.5010000@garzik.org>
Date: Thu, 25 Oct 2007 03:31:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ehea: fix port_napi_disable/enable
References: <200710241153.34992.ossthema@de.ibm.com>
In-Reply-To: <200710241153.34992.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> napi_disable / napi_enable must be applied on all ehea queues.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied


