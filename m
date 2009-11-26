Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZKZMjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZKZMjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZKZMjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:39:15 -0500
Received: from daytona.panasas.com ([67.152.220.89]:7929 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433AbZKZMjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:39:14 -0500
Message-ID: <4B0E76F5.1030006@panasas.com>
Date: Thu, 26 Nov 2009 14:39:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@citi.umich.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] lockd: Remove unused nfsd headers #includes
References: <4B0C1EB7.50508@panasas.com> <4B0C1FE0.8040105@panasas.com> <20091125201011.GG32502@fieldses.org> <20091125202323.GJ32502@fieldses.org>
In-Reply-To: <20091125202323.GJ32502@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2009 12:39:20.0785 (UTC) FILETIME=[79E71410:01CA6E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 10:23 PM, J. Bruce Fields wrote:
> On Wed, Nov 25, 2009 at 03:10:11PM -0500, J. Bruce Fields wrote:
>> On Tue, Nov 24, 2009 at 08:03:12PM +0200, Boaz Harrosh wrote:
>>>
>>> In what history where these ever needed? Well not
>>> any more.
>>
>> Applied, thanks.--b.
> 
> Um, I said that before I actually tried to compile it....  OK, dropping
> for now (assuming I'm missing some earlier patch).
> 
> --b.
> 

OK, I didn't realize it but, yes I have these on top of the previous 6
so it makes sense.

I have posted the previous 6 rebased on your new current tree, have you seen
it? All the patches are the same but [5/6] which has a "version 3". Do I need
to re post?

Thanks
Boaz
