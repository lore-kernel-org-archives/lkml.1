Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbZLEAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbZLEAAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZLEAAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:00:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbZLEAAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:00:07 -0500
Date: Fri, 4 Dec 2009 15:57:39 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
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
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/31] Constify struct sysfs_ops for 2.6.32 v1
Message-ID: <20091204155739.7a2abc60@nehalam>
In-Reply-To: <4B1991E2.5010903@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B1991E2.5010903@gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Dec 2009 23:49:06 +0100
Emese Revfy <re.emese@gmail.com> wrote:

> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct sysfs_ops.
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

Acked-by: Stephen Hemminger <shemminger@vyatta.com>

-- 
