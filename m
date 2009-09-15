Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZIOTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZIOTrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbZIOTrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:47:14 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48108 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758039AbZIOTrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:47:10 -0400
Message-ID: <4AAFEF48.8000607@sgi.com>
Date: Tue, 15 Sep 2009 12:47:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [GIT PULL] percpu for v2.6.32
References: <4AAF411C.2040501@kernel.org> <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1> <4AAFE9B2.1030006@kernel.org> <alpine.DEB.1.10.0909151531490.3340@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909151531490.3340@V090114053VZO-1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> On Wed, 16 Sep 2009, Tejun Heo wrote:
> 
>> Christoph Lameter wrote:
>>> On Tue, 15 Sep 2009, Tejun Heo wrote:
>>>
>>>> * All arches except for ia64 have been converted to use the new
>>>>   allocator.
>>> Any plans for this? The percpu operations patchset
>>> requires the new allocator to work on all platforms and I am wondering
>>> when I should repost the set.
>> I've been trying to get a cheap second hand itanium machine but itanic
>> really seems to have sunk pretty well.  It's almost impossible to find
>> one here.  I guess I'll have to bite the bullet and do it remotely.
>> There gotta be one with serial console and power control hooked up
>> somewhere in the company lab.  I'll try to locate one.
> 
> Maybe Mike knows of some way to get access to one?

We certainly have some in our labs but I'm not sure of one that's
externally accessible.  If there's a pre-defined test you'd like to
run, you can send me the details.  Otherwise, I'll check around and
see if there's a system available remotely.

Cheers,
Mike

