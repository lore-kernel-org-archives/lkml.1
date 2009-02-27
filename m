Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbZB0TIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbZB0TIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZB0TIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:08:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:50493 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZB0TIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:08:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,277,1233561600"; 
   d="scan'208";a="115165181"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 1/1] Fix PCI DMA flag propagation on SN (Altix) with PICs
Date: Fri, 27 Feb 2009 11:08:08 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "habeck@sgi.com" <habeck@sgi.com>
References: <20090227093835.GA306198@sgi.com>
In-Reply-To: <20090227093835.GA306198@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271108.08750.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 27, 2009 1:38:35 am Jeremy Higdon wrote:
> We recently discovered a problem with passing of DMA attributes on
> SN systems with the older PIC chips.
>
> Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

Hm, doubt it will apply (it came through my Exchange account so probably not); 
I usually have people send to my personal addr for that reason.  Do you need 
this in 2.6.29?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
