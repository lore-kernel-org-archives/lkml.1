Return-Path: <linux-kernel-owner+w=401wt.eu-S1765211AbXKOBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765211AbXKOBNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXKOBNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:13:22 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58063 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbXKOBNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:13:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Olof Johansson <olof@lixom.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix warning for token-ring from sysctl checker
References: <20071113072313.GB16842@lixom.net>
	<20071113.211540.97775009.davem@davemloft.net>
	<m1r6is253v.fsf@ebiederm.dsl.xmission.com>
	<20071114084528.0f092739.randy.dunlap@oracle.com>
	<20071115002810.GA7337@lixom.net>
Date: Wed, 14 Nov 2007 18:12:22 -0700
In-Reply-To: <20071115002810.GA7337@lixom.net> (Olof Johansson's message of
	"Wed, 14 Nov 2007 18:28:10 -0600")
Message-ID: <m18x50z4zt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> writes:

> On Wed, Nov 14, 2007 at 08:45:28AM -0800, Randy Dunlap wrote:
>> On Wed, 14 Nov 2007 08:56:20 -0700 Eric W. Biederman wrote:
>> 
>> > David Miller <davem@davemloft.net> writes:
>> > 
>> > > From: Olof Johansson <olof@lixom.net>
>> > > Date: Tue, 13 Nov 2007 01:23:13 -0600
>> > >
>> > >> As seen when booting ppc64_defconfig:
>> > >> 
>> > >> sysctl table check failed: /net/token-ring .3.14 procname does not match
>> > > binary path procname
>> > >> 
>> > >> 
>> > >> Signed-off-by: Olof Johansson <olof@lixom.net>
>> > >
>> > > Patch applied, thanks Olof.
>> > 
>> > No objections but I think we already have this fixed in the -mm tree.
>> 
>> Yes, I patched it several weeks ago and it's been in -mm for a while
>> now.  Apparently too long.
>
> Ah, sorry for the duplicate patch then. I must have missed it at the
> original posting (and didn't search that far back and/or -mm before
> posting it myself).

As long as the patch gets merged and makes it's way upstream so people
can use the token-ring code I don't really care who posts it.

Eric
