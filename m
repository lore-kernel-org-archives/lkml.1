Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXH1R1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXH1R1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXH1R1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:27:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:1556 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXH1R1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:27:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,317,1183359600"; 
   d="scan'208";a="269033747"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
Date: Tue, 28 Aug 2007 10:22:02 -0700
User-Agent: KMail/1.9.7
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20070826015556.GC14130@parisc-linux.org> <20070826140743.GF14130@parisc-linux.org> <46D1BF71.3020602@shaw.ca>
In-Reply-To: <46D1BF71.3020602@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281022.03429.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Greg, please drop Robert's patch and put mine in instead.
>
> Based on looking at your patch it seems OK. The first problem you
> mentioned with what Jesse and I had there is definitely a valid one.
>
> You can add my:
>
> Acked-by: Robert Hancock <hancockr@shaw.ca>

Yeah, thanks Matthew.

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
