Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXIRBsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXIRBsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXIRBsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:48:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbXIRBse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:48:34 -0400
Message-ID: <46EF2E5A.3060806@zytor.com>
Date: Mon, 17 Sep 2007 18:48:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -mm 2/2] i386/x86_64 boot: document for 32 bit boot	protocol
References: <1190017582.5866.22.camel@caritas-dev.intel.com>	 <46EE9D66.1030705@zytor.com> <1190078003.12429.8.camel@caritas-dev.intel.com>
In-Reply-To: <1190078003.12429.8.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> OK, I will check the actual structure, and change the document
> accordingly.
> 

The best would probably be to fix zero-page.txt (and probably rename it
something saner.)

	-hpa
