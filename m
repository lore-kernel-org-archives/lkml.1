Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYBRXyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYBRXyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBRXyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:54:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbYBRXye (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:54:34 -0500
Message-ID: <47BA1BE1.4060102@sgi.com>
Date: Tue, 19 Feb 2008 10:59:29 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com> <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 18 Feb 2008, Lachlan McIlroy wrote:
>> This will update the following files:
>>
>>  fs/xfs/Kbuild             |    6 --
>>  fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
>>  3 files changed, 117 insertions(+), 124 deletions(-)
>>  delete mode 100644 fs/xfs/Kbuild
> 
> Hmm. This didn't actually remove the old Makefile-linux-2.6 file, so it 
> exists as a zero-length file still.
> 
> Was that intentional?
No, not intentional, just the result of a merge failure I didn't clean up.
It shouldn't cause any problems and I'll delete it in the next batch of changes.

> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
