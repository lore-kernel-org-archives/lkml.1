Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZIOTXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZIOTXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZIOTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:23:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:35633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZIOTXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:23:49 -0400
Message-ID: <4AAFE9B2.1030006@kernel.org>
Date: Wed, 16 Sep 2009 04:23:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] percpu for v2.6.32
References: <4AAF411C.2040501@kernel.org> <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 19:23:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 15 Sep 2009, Tejun Heo wrote:
> 
>> * All arches except for ia64 have been converted to use the new
>>   allocator.
> 
> Any plans for this? The percpu operations patchset
> requires the new allocator to work on all platforms and I am wondering
> when I should repost the set.

I've been trying to get a cheap second hand itanium machine but itanic
really seems to have sunk pretty well.  It's almost impossible to find
one here.  I guess I'll have to bite the bullet and do it remotely.
There gotta be one with serial console and power control hooked up
somewhere in the company lab.  I'll try to locate one.

Thanks.

-- 
tejun
