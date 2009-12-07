Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbZLGRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbZLGRqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935462AbZLGRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:46:17 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:52351 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935373AbZLGRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:46:17 -0500
X-Loopcount0: from 143.166.82.43
Date: Mon, 7 Dec 2009 11:46:20 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
       lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, axboe@kernel.dk, gregkh@suse.de, petero2@telia.com,
       davej@redhat.com, maciej.sosnowski@intel.com, dougthompson@xmission.com,
       airlied@linux.ie, rolandd@cisco.com, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, neilb@suse.de, davem@davemloft.net,
       rdunlap@xenotime.net, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org, jbarnes@virtuousgeek.org, hjk@linutronix.de,
       david.vrabel@csr.com, jeremy@xensource.com, chris.mason@oracle.com,
       ccaulfie@redhat.com, teigland@redhat.com, tytso@mit.edu,
       adilger@sun.com, swhiteho@redhat.com, mfasheh@suse.com,
       joel.becker@oracle.com, rusty@rustcorp.com.au, penberg@cs.helsinki.fi,
       shemminger@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/31] Constify struct sysfs_ops for 2.6.32 v1
Message-ID: <20091207174620.GA16608@auslistsprd01.us.dell.com>
References: <4B198670.2000406@gmail.com> <4B1991E2.5010903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1991E2.5010903@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:49:06PM +0100, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct sysfs_ops.
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  drivers/firmware/edd.c                |    2 +-
>  drivers/firmware/efivars.c            |    2 +-

Acked-by: Matt Domsch <Matt_Domsch@dell.com>


-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
