Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbXGFJg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbXGFJg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXGFJgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:36:20 -0400
Received: from waldorf.cs.uni-dortmund.de ([129.217.4.42]:56647 "EHLO
	waldorf.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761037AbXGFJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:36:20 -0400
Date: Fri, 6 Jul 2007 11:36:18 +0200
From: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
To: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
Message-Id: <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <200707061413.53182.surenkarapetyan@gmail.com>
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
	<200707061413.53182.surenkarapetyan@gmail.com>
Organization: Universitaet Dortmund
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; sparc-sun-solaris2.8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> In recent kernels both PATA and SATA (SCSI too) drives are handled by
> libata  library. It calls all the drives sd* . 

If so, what about the use of hdparm then? I could not change parameters
like DMA, MultSectIO and 32-Bit support with hdparm. sdparm also did not
do that work.

Regards
  Christoph  
