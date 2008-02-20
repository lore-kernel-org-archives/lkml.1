Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbYBTPbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbYBTPbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbYBTP2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:28:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932315AbYBTP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:28:06 -0500
Message-ID: <47BC4702.5090407@sgi.com>
Date: Wed, 20 Feb 2008 07:28:02 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Optimize percpu accesses v3
References: <20080219203335.866324000@polaris-admin.engr.sgi.com> <20080220091529.GD31424@elte.hu>
In-Reply-To: <20080220091529.GD31424@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> This patchset is the x86-specific part split from the generic part of 
>> the zero-based patchset.
> 
> thanks Mike, applied them to x86.git. Do these depend on the generic 
> bits? (for now we'll keep these in -testing, so that they do not reach 
> -mm)
> 
> 	Ingo

Umm, yes, the generic part provides the groundwork for the x86 part.

Thanks,
Mike
