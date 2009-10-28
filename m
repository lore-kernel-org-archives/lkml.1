Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbZJ1D3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbZJ1D3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbZJ1D3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:29:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZJ1D3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:29:51 -0400
Date: Wed, 28 Oct 2009 04:29:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091028032954.GD7744@basil.fritz.box>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <4AE75B38.8070301@sgi.com> <alpine.DEB.2.00.0910271345400.9183@chino.kir.corp.google.com> <4AE77BF6.2040201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE77BF6.2040201@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Quite the system you have there :)  What was once 760 lines has been 
>> reduced to 24 without removing any information.
>>
>> This seems to be the most we can reduce this particular output since we 
>> don't support mapping multiple pxms to a single node.
>
> Yes, thanks very much for the optimization.
>
> (And you can add my Acked-by or whatever you need.)

Looks also good to me, thanks. Also Acked-by.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
