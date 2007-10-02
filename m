Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXJBSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXJBSsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXJBSrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:47:47 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:29397 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195AbXJBSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:47:45 -0400
X-Trace: 629771568-mk-filter-3.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAOYuAkdRAUxC/2dsb2JhbACBWQ
Subject: Re: [PATCH] Fix SH DMA API so it works with PVR cascade
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1191348942.12347.7.camel@localhost.localdomain>
References: <1191348942.12347.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 19:47:23 +0100
Message-Id: <1191350843.17654.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 19:15 +0100, Adrian McMenamin wrote:
> This patch - hope it is not too late for 2.6.24 queue - gets the SH DMA
> API to work properly for the PVR2 DMA cascade.
> 
Please ignore this - sent in error - and look at
http://lkml.org/lkml/2007/10/2/276
