Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbXHTRFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbXHTRFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXHTRFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:05:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734AbXHTRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:05:32 -0400
Message-ID: <46C9C9C7.8080506@zytor.com>
Date: Mon, 20 Aug 2007 10:05:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815161642.1bfbbe9c.akpm@linux-foundation.org>	 <46C38AA8.5040202@zytor.com>	 <1187251248.15063.12.camel@caritas-dev.intel.com>	 <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com> <86802c440708191646r1caab5d8yd82c55fd2c8262db@mail.gmail.com>
In-Reply-To: <86802c440708191646r1caab5d8yd82c55fd2c8262db@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> someone told me that EFI PEI will be 32 bit ( for mem etc
> initialization), and after that will be 64 bit, so the Run time
> service will be 64 bit only, and it will only support 64 bit OS with
> EFI. and they have another mode to emulate the legacy BIOS to boot
> 32bit OS.
> 

That seems unlikely for e.g. the existing Macs already in the field.

*Sigh.*

	-hpa
