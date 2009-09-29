Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZI2LBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZI2LBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZI2LBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:01:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753614AbZI2LBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:01:23 -0400
Date: Tue, 29 Sep 2009 11:57:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging/et131x:  adding __init/__exit macros
Message-ID: <20090929115728.3346b06d@lxorguk.ukuu.org.uk>
In-Reply-To: <200909290134.15295.PeterHuewe@gmx.de>
References: <200909290134.15295.PeterHuewe@gmx.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 01:34:14 +0200
Peter Huewe <PeterHuewe@gmx.de> wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of ./staging/et131x/et131x_initpci.c
> 
> Greg, please have a look at the small patch and either pull it through
> your staging tree, or please ack' it so Jiri can pull it through the trivial tree.
> 
> linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Alan Cox <alan@linux.intel.com>
