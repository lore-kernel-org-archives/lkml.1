Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYJCGuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYJCGuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYJCGt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:49:57 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:38413 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753327AbYJCGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:49:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=s2CqUT7mKdvX8k08sokKyYgA3a3j4lIarQbqnVY5X3fzPT4+GQ3rNxbn0D+NnG5GaAHjWbeKyes3fGpj7614BG0VwwwtXO3CI1vnilqGQ3l2fZz1TibzatlJXwU/1RWfCsZeu8ZsOS1JCp/fFf7X7cEcbTO2FwRKC6M13r+1LSI=  ;
X-YMail-OSG: mtQPl7QVM1kp4UTThU9_afa4xOn6VyQsqY12diLkgoMS1bNcKma7mnfM61ZrxWCJrHT4bky9KrIqyhKqyfnsCpAlRG9TUizQ_5nzkrxsCtbkV4NdtB6qw2It3mdufta_NeEP2.a5LsmLp14St4neB2.1ZDSsVQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
Date: Fri, 3 Oct 2008 16:49:47 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
References: <20081002130504.927878499@chello.nl>
In-Reply-To: <20081002130504.927878499@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031649.47800.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 23:05, Peter Zijlstra wrote:
> Patches are against: v2.6.27-rc5-mm1
>
> This release features more comments and (hopefully) better Changelogs.
> Also the netns stuff got sorted and ipv6 will now build and not oops
> on boot ;-)
>
> The first 4 patches are cleanups and can go in if the respective
> maintainers agree.
>
> The code is lightly tested but seems to work on my default config.
>
> Let's get this ball rolling...

I know it's not too helpful for me to say this, but I am spending
time looking at this stuff. I have commented on it in the past,
but I want to get a good handle on the code before I chime in again.
