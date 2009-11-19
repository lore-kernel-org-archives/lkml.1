Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZKSNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZKSNdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZKSNdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:33:39 -0500
Received: from mga05.intel.com ([192.55.52.89]:21448 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbZKSNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:33:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,771,1249282800"; 
   d="scan'208";a="748528199"
Date: Thu, 19 Nov 2009 13:16:36 +0000
From: Alan Cox <alan@linux.intel.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119131636.15800a11@linux.intel.com>
In-Reply-To: <200911182056.16517.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<20091118184125.623e063d@lxorguk.ukuu.org.uk>
	<200911182007.07405.bzolnier@gmail.com>
	<200911182056.16517.bzolnier@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only pata_hpt37x has broken cable detection while pata_hpt3x2n is
> okay. ;)

I think you have that backwards according to the vendor drivers. 3x2n
looks like it needs adjusting.
 

