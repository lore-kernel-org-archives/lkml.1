Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbXGZXbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbXGZXbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbXGZXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:31:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:33362 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbXGZXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:31:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,585,1175497200"; 
   d="scan'208";a="255315054"
Message-ID: <46A92EBC.90803@intel.com>
Date: Thu, 26 Jul 2007 16:31:08 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bjorn.helgaas@hp.com
Subject: Re: Fwd: PNP: Lindent all source files
References: <46A928D2.6030702@simon.arlott.org.uk>
In-Reply-To: <46A928D2.6030702@simon.arlott.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2007 23:31:09.0672 (UTC) FILETIME=[0BD72680:01C7CFDD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> Does anyone ever review what Lindent does? There's a fix up patch after this 
> but it missed this at the very top of the patch and the labels.

Lindent fails on several things really badly (case/labels mostly), but it is 
unmaintained and nobody seems to want to make it understand 
--i-want-linus-style-dammit options :(

Auke
