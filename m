Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZKLTNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZKLTNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZKLTNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:13:07 -0500
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:44249
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbZKLTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:13:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=laF757P+xvTs+WBNQKhUXXaGYgEbRSKj+P9IF0cKOpIDKkwGbFl344810xpzPrie;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4AFC5E3F.7070609@earthlink.net>
Date: Thu, 12 Nov 2009 14:13:03 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] Documentation: rw_lock lessons learned
References: <4AF9C540.5090403@gmail.com>	<20091110180646.2e5859a8@nehalam>	<4AFAEF78.4080807@gmail.com> <20091111093724.4f40a48d@nehalam> <4AFBEC44.9030409@gmail.com>
In-Reply-To: <4AFBEC44.9030409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79858e8d629c1722b1b37afc45b4e9fa05350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> In recent weeks, two different network projects erroneously
> strayed down the rw_lock path.  Update the Documentation
> based upon comments by Eric Dumazet and Paul E. McKenney in
> those threads.
> 
> Merged with editorial changes by Stephen Hemminger.
> 
> Signed-off-by: William.Allen.Simpson@gmail.com
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  Documentation/spinlocks.txt |  186 
> ++++++++++++++++++++-----------------------
>  1 files changed, 86 insertions(+), 100 deletions(-)
> 

How up to date is this doc?

http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/index.html

Should it be in the Documentation directory?


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


