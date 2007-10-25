Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXJYWmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXJYWmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXJYWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:42:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60773 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbXJYWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:42:44 -0400
Message-ID: <47211BE2.10405@garzik.org>
Date: Thu, 25 Oct 2007 18:42:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate
 struct pci_dev members
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234827.74AD61F81A1@havoc.gtf.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD02@otce2k301.adaptec.com>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD02@otce2k301.adaptec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for reviewing these!

