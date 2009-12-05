Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZLEVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZLEVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 16:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZLEVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 16:15:23 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZLEVPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 16:15:23 -0500
Date: Sat, 5 Dec 2009 22:15:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
       lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, gregkh@suse.de, petero2@telia.com, davej@redhat.com,
       maciej.sosnowski@intel.com, dougthompson@xmission.com, airlied@linux.ie,
       rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       neilb@suse.de, rdunlap@xenotime.net, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org, jbarnes@virtuousgeek.org, hjk@linutronix.de,
       david.vrabel@csr.com, jeremy@xensource.com, chris.mason@oracle.com,
       ccaulfie@redhat.com, teigland@redhat.com, tytso@mit.edu,
       adilger@sun.com, swhiteho@redhat.com, mfasheh@suse.com,
       joel.becker@oracle.com, rusty@rustcorp.com.au, penberg@cs.helsinki.fi,
       shemminger@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/31] Constify struct sysfs_ops for 2.6.32 v1
Message-ID: <20091205211527.GH8742@kernel.dk>
References: <4B198670.2000406@gmail.com> <4B1991E2.5010903@gmail.com> <4B19A33B.9050907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B19A33B.9050907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05 2009, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct sysfs_ops.
> Per Dave Miller's suggestion, resend with proper CC list and patch format.

For the block parts:

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

