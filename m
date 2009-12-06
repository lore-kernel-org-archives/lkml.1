Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZLFI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZLFI6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZLFI6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:58:48 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36089 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZLFI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:58:47 -0500
Subject: Re: [PATCH 29/31] Constify struct sysfs_ops for 2.6.32 v1
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Emese Revfy <re.emese@gmail.com>, tony.luck@intel.com,
       fenghua.yu@intel.com, benh@kernel.crashing.org, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@suse.de,
       petero2@telia.com, davej@redhat.com, maciej.sosnowski@intel.com,
       dougthompson@xmission.com, airlied@linux.ie, rolandd@cisco.com,
       sean.hefty@intel.com, hal.rosenstock@gmail.com, neilb@suse.de,
       rdunlap@xenotime.net, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org, jbarnes@virtuousgeek.org, hjk@linutronix.de,
       david.vrabel@csr.com, jeremy@xensource.com, chris.mason@oracle.com,
       ccaulfie@redhat.com, teigland@redhat.com, tytso@mit.edu,
       adilger@sun.com, swhiteho@redhat.com, mfasheh@suse.com,
       joel.becker@oracle.com, rusty@rustcorp.com.au,
       shemminger@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20091205211527.GH8742@kernel.dk>
References: <4B198670.2000406@gmail.com> <4B1991E2.5010903@gmail.com>
	 <4B19A33B.9050907@gmail.com>  <20091205211527.GH8742@kernel.dk>
Date: Sun, 06 Dec 2009 10:58:51 +0200
Message-Id: <1260089931.16254.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 22:15 +0100, Jens Axboe wrote:
> On Sat, Dec 05 2009, Emese Revfy wrote:
> > From: Emese Revfy <re.emese@gmail.com>
> > 
> > Constify struct sysfs_ops.
> > Per Dave Miller's suggestion, resend with proper CC list and patch format.
> 
> For the block parts:
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>

For the SLUB parts:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

