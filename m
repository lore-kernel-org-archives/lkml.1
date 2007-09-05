Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXIEOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXIEOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXIEOxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:53:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52898 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbXIEOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:53:03 -0400
Message-ID: <46DEC14C.8050001@sgi.com>
Date: Wed, 05 Sep 2007 07:46:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, clameter@sgi.com, steiner@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
 (v2) (fwd)
References: <Pine.LNX.4.64.0708312028400.24049@schroedinger.engr.sgi.com>	<20070904141055.e00a60d7.akpm@linux-foundation.org>	<46DDE623.1090402@sgi.com>	<200709050910.10954.ak@suse.de> <20070905014057.bf3d2f22.akpm@linux-foundation.org>
In-Reply-To: <20070905014057.bf3d2f22.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
>> On Wed, 5 Sep 2007 09:10:10 +0100 Andi Kleen <ak@suse.de> wrote:
>>> I can easily do the changes for ia64 and test them.  I don't have the
>>> capability of testing on the powerpc.
>> You can get cross compilers and make it compile
> 
> http://userweb.kernel.org/~akpm/cross-compilers/

Thanks Andrew!

It's an extensive list but I didn't see one for ppc64?

Regards,
Mike
