Return-Path: <linux-kernel-owner+w=401wt.eu-S1767683AbXCJA2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767683AbXCJA2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767687AbXCJA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:28:08 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:46376 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1767683AbXCJA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:28:07 -0500
Date: Fri, 9 Mar 2007 16:06:17 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Al Boldi <a1426z@gawab.com>
cc: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair 
 starvation free interactive cpu scheduler)
In-Reply-To: <200703092343.46276.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.63.0703091604180.31392@qynat.qvtvafvgr.pbz>
References: <200703091625.55361.a1426z@gawab.com>  <20070309135751.GE2986@holomorphy.com>
 <200703092343.46276.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Al Boldi wrote:

>
>> My preferred sphere of operation is the Manichean domain of faster vs.
>> slower, functionality vs. non-functionality, and the like. For me, such
>> design concerns are like the need for a kernel to format pagetables so
>> the x86 MMU decodes what was intended, or for a compiler to emit valid
>> assembly instructions, or for a programmer to write C the compiler
>> won't reject with parse errors.
>
> Sure, but I think, even from a technical point of view, competition is a good
> thing to have.  Pluggable schedulers give us this kind of competition, that
> forces each scheduler to refine or become obsolete.  Think evolution.

The point Linus is makeing is that with pluggable schedulers there isn't 
competition between them, the various developer teams would go off in their own 
direction and any drawbacks to their scheduler could be answered with "that's 
not what we are good at, use a different scheduler", with the very real 
possibility that a person could get this answer from ALL schedulers, leaving 
them with nothing good to use.

David Lang
