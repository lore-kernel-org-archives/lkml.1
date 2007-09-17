Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXIQOac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXIQOac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXIQOaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:30:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:33989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbXIQOaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:30:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC -mm 0/2] i386/x86_64 boot: 32-bit boot protocol
Date: Mon, 17 Sep 2007 16:30:17 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1190017572.5866.20.camel@caritas-dev.intel.com> <200709171040.27043.ak@suse.de> <1190018855.5866.27.camel@caritas-dev.intel.com>
In-Reply-To: <1190018855.5866.27.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171630.18066.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The real contents of 32-bit boot protocol patch is is in another 2 mails
> with the title:
> 
> [RFC -mm 1/2] i386/x86_64 boot: setup data
> [RFC -mm 2/2] i386/x86_64 boot: document for 32 bit boot protocol
> 
> The EFI patch in this mail is just an example of 32-bit boot protocol
> usage.

Please write meaningfull descriptions for each patch then. Just duplicating
the same in each is pretty useless.

-Andi
