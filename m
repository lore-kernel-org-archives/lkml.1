Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbXJ0Ah7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbXJ0Ah7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXJ0Ahw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:37:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52085 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXJ0Ahv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:37:51 -0400
Message-ID: <4722885B.7050307@garzik.org>
Date: Fri, 26 Oct 2007 20:37:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075808.GH6407@havoc.gtf.org>	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>	<20071026143525.b9218ed7.akpm@linux-foundation.org>	<4722608E.3000405@garzik.org>	<20071026165035.33383e36@laptopd505.fenrus.org>	<47228278.8070505@garzik.org> <20071026171606.4e242f49@laptopd505.fenrus.org>
In-Reply-To: <20071026171606.4e242f49@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> the other serious question is.. how is IRQ_HANDLER_V3 different from a
> #ifdef VERSION >= 2.6.24 .....
> it's not really ;)

Note my mention of backport -- kernel version isn't relevant when the 
various enterprise distros have random featuresets under random kernel 
versions.

	Jeff


