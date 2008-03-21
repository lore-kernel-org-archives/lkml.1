Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYCUNlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYCUNlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYCUNlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYCUNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:41:42 -0400
Message-ID: <47E3B84C.6070808@zytor.com>
Date: Fri, 21 Mar 2008 06:29:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] x86: PAT support updated - v3
References: <20080319000012.439150000@intel.com>
In-Reply-To: <20080319000012.439150000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:
> * UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.

I have to say I think this looks like a good patchset.  However, I'd 
like a bit more clarification with regards to the above point?

	-hpa
