Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbXF1X5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbXF1X5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbXF1X5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:57:15 -0400
Received: from mail18.syd.optusnet.com.au ([211.29.132.199]:52560 "EHLO
	mail18.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948AbXF1X5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:57:14 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: Wrong cache size reported on Q6600
Date: Fri, 29 Jun 2007 09:57:08 +1000
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200706290931.45355.kernel@kolivas.org> <20070628233312.GB30594@linux-os.sc.intel.com>
In-Reply-To: <20070628233312.GB30594@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706290957.08128.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007 09:33, Siddha, Suresh B wrote:
> On Fri, Jun 29, 2007 at 09:31:44AM +1000, Con Kolivas wrote:
> > This is a Q6600 which has cache size of 8 MB. Unless it's reporting each
> > half's effective L2, I think it should be reporting 8192 instead of 4096.
>
> There are two L2's, each of 4MB. Each L2 shared by two cores.

That was what I wasn't sure of as I said above; thanks for clarifying.

-- 
-ck
