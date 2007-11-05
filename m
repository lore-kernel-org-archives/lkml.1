Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbXKER1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbXKER1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbXKERWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:22:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:5437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760226AbXKERWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:22:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,373,1188802800"; 
   d="scan'208";a="196381711"
Date: Mon, 5 Nov 2007 09:21:02 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-Id: <20071105092102.bda06ac0.kristen.c.accardi@intel.com>
In-Reply-To: <472F1266.80207@garzik.org>
References: <20071031201308.GK11514@kernel.dk>
	<20071101084145.GA5037@kernel.dk>
	<20071102163708.15304989.kristen.c.accardi@intel.com>
	<20071105124711.GF5359@kernel.dk>
	<472F1266.80207@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2007 07:53:58 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> > Yep, works for me! Can we get this expedited upstream?
> 
> If everybody's happy with it, I've got it ready for upstream in 
> libata-dev.git#dlpm-fix
> 
> 	Jeff

Thanks! It'd be great if you could get it in ASAP.
