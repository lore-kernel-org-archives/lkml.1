Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbXFLEn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbXFLEn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXFLEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:43:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51634 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXFLEnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:43:18 -0400
Message-ID: <466E2460.3050703@garzik.org>
Date: Tue, 12 Jun 2007 00:43:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <466E1EC6.90509@linux.intel.com>
In-Reply-To: <466E1EC6.90509@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We will do AHCI link PM -- presuming that I can be convinced that it 
does not repeatedly park the hard drive heads, or something similarly 
annoying on PATA<->SATA bridges and similar setups.

IF it works as advertised -- a big if considering all the AHCI silicon 
implementations out there -- we definitely want to use it.

	Jeff



