Return-Path: <linux-kernel-owner+w=401wt.eu-S2993153AbXDSHxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993153AbXDSHxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993156AbXDSHxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:53:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993153AbXDSHxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:53:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=bYsELil2NGZv2FHqB7M4f6ZOnBD2d+OHZRxVci1lUUCF3xEWEf1oYtK+UYweRg81n
	rcVWI5Ne4JIaIcaPTvClw==
Message-ID: <46271FB7.9030408@google.com>
Date: Thu, 19 Apr 2007 00:52:23 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com> <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com> <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com> <4626CEDA.7050608@google.com> <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 18 Apr 2007, Ethan Solomita wrote:
>
>   
>>    Any new ETA? I'm trying to decide whether to go back to your original
>> patches or wait for the new set. Adding new knobs isn't as important to me as
>> having something that fixes the core problem, so hopefully this isn't waiting
>> on them. They could always be patches on top of your core patches.
>>    -- Ethan
>>     
>
> Hmmmm.... Sorry. I got distracted and I have sent them to Kame-san who was 
> interested in working on them. 
>
> I have placed the most recent version at
> http://ftp.kernel.org/pub/linux/kernel/people/christoph/cpuset_dirty
>   

    Do you expect any conflicts with the per-bdi dirty throttling patches?
    -- Ethan

