Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbYHEBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbYHEBiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYHEBh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:37:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34610 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476AbYHEBh4 (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:37:56 -0400
Message-ID: <4897B05A.7040002@sgi.com>
Date: Tue, 05 Aug 2008 11:43:54 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com,
       xen-devel@lists.xensource.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de> <4896A197.3090004@sgi.com> <200808042057.20607.nickpiggin@yahoo.com.au>
In-Reply-To: <200808042057.20607.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay.  When the time comes will you push the XFS changes to mainline
or would you like us to?

Nick Piggin wrote:
> Thanks for taking a look. I'll send them over to -mm with patch 1,
> then, for some testing.
> 
> On Monday 04 August 2008 16:28, Lachlan McIlroy wrote:
>> Looks good to me.
>>
>> Nick Piggin wrote:
>>> Implement XFS's large buffer support with the new vmap APIs. See the vmap
>>> rewrite patch for some numbers.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
