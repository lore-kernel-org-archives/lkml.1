Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbXI0LtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbXI0LtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXI0LtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:49:03 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:51378 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXI0LtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:49:01 -0400
Date: Thu, 27 Sep 2007 12:48:59 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] MIPS: Remove deprecated IRQ flags (SA_*)
Message-ID: <20070927114859.GA26650@linux-mips.org>
References: <20070926223343.GA25905@Ahmed> <20070926223543.GB25905@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926223543.GB25905@Ahmed>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 01:35:43AM +0300, Ahmed S. Darwish wrote:

> A patch to stop using deprecated IRQ flags. The new IRQF_* macros are used
> instead.

Thanks, queued for 2.6.24.

  Ralf
