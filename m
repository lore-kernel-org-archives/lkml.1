Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXFAF4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXFAF4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbXFAF4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:56:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42530 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbXFAF4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:56:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Ellerman" <michael@ellerman.id.au>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<dc1166600705312052j490b1fads17e190249d178406@mail.gmail.com>
Date: Thu, 31 May 2007 23:55:28 -0600
In-Reply-To: <dc1166600705312052j490b1fads17e190249d178406@mail.gmail.com>
	(Michael Ellerman's message of "Fri, 1 Jun 2007 13:52:28 +1000")
Message-ID: <m1tzts1anj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Ellerman" <michael@ellerman.id.au> writes:

> On 5/31/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
> ...
>> +msi-fix-the-ordering-of-msix-irqs.patch
>> +msi-mask-the-msix-vector-before-we-unmap-it.patch
> ...
>>  2.6.22 probable-queue
>
> I think these two should be in the 2.6.22 definite-queue, unless Eric disagrees.

They are simple bug fixes for regression in 2.6.22 so I don't see a reason
to delay them.

Eric
