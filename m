Return-Path: <linux-kernel-owner+w=401wt.eu-S1031104AbXEEDPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031104AbXEEDPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031127AbXEEDPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:15:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50453 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031104AbXEEDPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:15:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, jeremy@goop.org, zach@vmware.com,
       torvalds@linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
References: <1178289450.23670.100.camel@localhost.localdomain>
	<m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
	<1178328168.12284.11.camel@localhost.localdomain>
	<20070504.194526.53338219.davem@davemloft.net>
Date: Fri, 04 May 2007 21:14:42 -0600
In-Reply-To: <20070504.194526.53338219.davem@davemloft.net> (David Miller's
	message of "Fri, 04 May 2007 19:45:26 -0700 (PDT)")
Message-ID: <m14pmsneql.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Sat, 05 May 2007 11:22:48 +1000
>
>> Hi Eric,
>
> To all of those who don't speak "rusty", "Hi Soandso" means
> "NAK".

The question between Rusty and myself is not if we should remove
that code but when. 

If we are going to break an ABI I figure the sooner the better,
and the conversation between Rusty and myself has not been totally
unproductive.

Eric
