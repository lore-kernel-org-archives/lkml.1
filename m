Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXEPPds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXEPPds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbXEPPdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:33:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57857 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbXEPPdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:33:41 -0400
Message-ID: <464B244D.6050301@garzik.org>
Date: Wed, 16 May 2007 11:33:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>	<20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>	<464AB9B0.9070205@garzik.org> <20070516010459.0435d71c.akpm@linux-foundation.org>
In-Reply-To: <20070516010459.0435d71c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yes, but it seems wrong to disable all of libsas if !ATA.  Only sas_ata.o
> should depend on that.

Agreed.

	Jeff


