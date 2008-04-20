Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYDTLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYDTLt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYDTLtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:49:12 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35277 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYDTLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:49:09 -0400
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Adrian Bunk <bunk@kernel.org>, Oliver Pinter <oliver.pntr@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
	<20080419151911.GB1595@cs181133002.pp.htv.fi>
	<480AA2B9.10305__23983.3358479247$1208657639$gmane$org@sandeen.net>
Date: Sun, 20 Apr 2008 13:48:40 +0200
In-Reply-To: <480AA2B9.10305__23983.3358479247$1208657639$gmane$org@sandeen.net> (Eric Sandeen's message of "Sat, 19 Apr 2008 20:56:09 -0500")
Message-ID: <87abjobvc7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 11:41:52.0779 (UTC) FILETIME=[87135DB0:01C8A2DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:

> Adrian Bunk wrote:
>> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
>>> ...
>>> with the older kernel is typical: xfs+nfs+4k stack(+lvm)
>> 
>> Does anyone still experience problems with 2.6.25?
>
> There are always problems.  You can always come up with something that
> will crash in 4k, IMHO.

But what are a few crashes compared against the ability to run 50000
kernel threads on a 32bit machine? Something has to give in the aim
for useless checkbox numbers after all. 

-Andi
