Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYLaBnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYLaBnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYLaBnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:43:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751853AbYLaBnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:43:39 -0500
Message-ID: <495ACEB2.1080105@sgi.com>
Date: Wed, 31 Dec 2008 12:45:22 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
Organization: SGI
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.29
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com> <alpine.LFD.2.00.0812301738250.3082@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812301738250.3082@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Dec 2008, Lachlan McIlroy wrote:
>> The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:
>>   Linus Torvalds (1):
>>         Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc
>>
>> are available in the git repository at:
>>
>>   git://oss.sgi.com/oss/git/xfs/xfs.git for-linus
> 
> Not to me they aren't:
> 
> 	fatal: The remote end hung up unexpectedly
> 
> Hmm?
Linus,

Could you please try

git://oss.sgi.com/xfs/xfs.git for-linus

(the /oss/git prefix is needed for ssh - I should have noticed that)

Thanks.

> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

