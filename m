Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXCWI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXCWI7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422743AbXCWI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:59:23 -0400
Received: from hosting4p.com ([81.0.235.160]:46982 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422740AbXCWI7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:59:23 -0400
Message-ID: <460396F5.5020509@slax.org>
Date: Fri, 23 Mar 2007 09:59:33 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
References: <1696002332@web.de>
In-Reply-To: <1696002332@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> wondering that here are 13 postings about loopdevice limitation, but
> nobody giving any comment about dm-loop (
> http://sources.redhat.com/lvm2/wiki/DMLoop ), which is a solution for
> this problem ......

If I understand it correctly, I would need 'dm' in kernel (or module) 
and moreover I would need some userspace utilities/binaries.

 > It can be used as a 1:1 replacement for classic loop and
 > should (?) probably be ready for mainline in the not too far future.

So it is not in Kernel?

With current loop, people would need kernel patch and *no* userspace 
utilities.
With dm-loop, people would need kernel patch *and* userspace utilities.
So, from my point of view, it would be better to fix/enhance Linux's loop.


Tomas M
slax.org
