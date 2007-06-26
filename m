Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbXFZP2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbXFZP2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXFZP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:28:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:59648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbXFZP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:28:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="259046025"
Date: Tue, 26 Jun 2007 08:24:42 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Message-Id: <20070626082442.50ae810e.kristen.c.accardi@intel.com>
In-Reply-To: <20070622190000.GK30033@kernel.dk>
References: <20070611184146.448266229@intel.com>
	<20070620142342.404856fe.kristen.c.accardi@intel.com>
	<20070621130831.GN18863@kernel.dk>
	<20070622101509.16d0e93d.kristen.c.accardi@intel.com>
	<20070622190000.GK30033@kernel.dk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 21:00:00 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Exactly, it needs to be handled by some power management daemon anyway
> and be integrated with power savings in general. You could use io load
> to determine when to enable/disable alpm, for instance.
> 
> > Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Will you integrate it into the next posting?

yes, I will do that.


Kristen
