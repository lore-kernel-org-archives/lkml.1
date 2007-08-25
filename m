Return-Path: <linux-kernel-owner+w=401wt.eu-S1765586AbXHYElg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765586AbXHYElg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXHYElV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:41:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42179 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXHYElT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:41:19 -0400
Message-ID: <46CFB2ED.3010901@garzik.org>
Date: Sat, 25 Aug 2007 00:41:17 -0400
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
Subject: Re: [PATCH 1/4] ehea: fix interface to DLPAR tools
References: <200708221620.59078.ossthema@de.ibm.com>
In-Reply-To: <200708221620.59078.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Userspace DLPAR tool expects decimal numbers to be written to
> and read from sysfs entries.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied 1-3


