Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXCUVLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXCUVLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXCUVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:11:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974AbXCUVLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:11:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=vdHFOdjtXMCPD+mg7p735FWaK6RR78JVDaw88Tz3VNVCbKdEb4NQ0BsAoHHij2FkT
	UgEr5cj5Bry0X/A92Qgtg==
Message-ID: <46019F67.3010300@google.com>
Date: Wed, 21 Mar 2007 14:11:03 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com> <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 1 Feb 2007, Ethan Solomita wrote:
> 
>>    Hi Christoph -- has anything come of resolving the NFS / OOM concerns that
>> Andrew Morton expressed concerning the patch? I'd be happy to see some
>> progress on getting this patch (i.e. the one you posted on 1/23) through.
> 
> Peter Zilkstra addressed the NFS issue. I will submit the patch again as 
> soon as the writeback code stabilizes a bit.

	I'm pinging to see if this has gotten anywhere. Are you ready to 
resubmit? Do we have the evidence to convince Andrew that the NFS issues 
are resolved and so this patch won't obscure anything?

	Thanks,
	-- Ethan
