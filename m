Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZGWBYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZGWBYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZGWBYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZGWBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:24:54 -0400
Message-ID: <4A67BBDC.7040207@zytor.com>
Date: Wed, 22 Jul 2009 18:24:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.1) Gecko/20090715 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       denis@compulab.co.il
Subject: Re: [PATCH] Add reboot fixup for SBC-fitPC2
References: <4A6491C1.5060909@compulab.co.il> <20090722173854.fdbcee7f.akpm@linux-foundation.org>
In-Reply-To: <20090722173854.fdbcee7f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 05:38 PM, Andrew Morton wrote:
> 
> Neither this patch nor Denis's earlier version contained an adequate
> decription.  We aren't told what these "problems" are, so we're unable
> to judge the appropriateness of patch.
> 
> Both patches were wordwrapped.
> 
> Both patches use an atypical layout style for the comments.
> 
> I fixed up some of these things and merged the patch into my tree, for
> sending to Ingo for 2.6.32.
> 
> Please send a description of the problem which the patch fixes and I
> shall add that to my copy of the changelog.
> 

I queued up an equivalent cleaned up version for tip:x86/urgent that I
was planning to push to Linus.  However, as you quite correctly point
out the comments in this file are pretty darn pointless; they add
absolutely no information over what is already in the data structure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

