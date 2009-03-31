Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbZCaXvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbZCaXvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbZCaXvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:51:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54282 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbZCaXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:51:42 -0400
Date: Tue, 31 Mar 2009 19:50:57 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add hvc_console to MAINTAINERS
Message-ID: <20090331235057.GB563@zod.rchland.ibm.com>
References: <49BF956B.9030109@gmail.com> <20090330133531.f5d99c09.akpm@linux-foundation.org> <20090330205553.GA19278@yoda.jdub.homelinux.org> <20090330141852.59baaeda.akpm@linux-foundation.org> <20090331132944.GB2332@yoda.jdub.homelinux.org> <1238543040.6522.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238543040.6522.10.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 10:44:00AM +1100, Michael Ellerman wrote:
>On Tue, 2009-03-31 at 09:29 -0400, Josh Boyer wrote:
>> Add a MAINTAINERS entry for the hypervisor virtual console support
>> used on IBM POWER servers.
>> 
>> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
>> ---
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c5f4e9d..387ad45 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
>>  T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
>>  S:     Maintained
>>  
>> +IBM HYPERVISOR VIRTUAL CONSOLE
>> +P:     Several
>> +L:     linuxppc-dev@ozlabs.org
>> +S:     Maintained
>
>I don't think it's the "IBM" Hypervisor virtual console driver anymore.
>There are backends for Xen, Beat (Toshiba) and virtio. 

Was just going by the copyright in the files, and Documentation/powerpc/hvc*

Also, if there are other backends, then is the list specified really
correct?  Perhaps it should just be linux-kernel.

Guess that's the problem with trying to add a maintainers entry for something
that doesn't really have a specific maintainer.

josh
