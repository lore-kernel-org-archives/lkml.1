Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYGUGNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYGUGNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYGUGNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:13:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:18629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYGUGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lQQyKs1hhEVTErVkXq85jcgp1nCqCzd1xoeZKpk8J853/vHrQ9CHqbTkS8mWWKOgiw
         wuNF6J931MBwy6LHgfAIjRo3nPIueA5n+3qexp2RfV+4WsXIyFRn79YmbMFkvi+0H8oX
         /wCKcS92eLRb+2YqrdJKKR2THuqDNgWplNQsE=
Subject: Re: linux-next: please hold off 2.6.28 stuff
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080721135108.d4ca4be5.sfr@canb.auug.org.au>
References: <20080721135108.d4ca4be5.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 23:13:41 -0700
Message-Id: <1216620821.13328.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 13:51 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Andrew mentioned this and I just thought I would reinforce the message:
> 
> Please do not put 2.6.28 code into linux-next until at least after -rc1.
> This will help Andrew's sanity :-)

I would say let -rc2 be the flag for putting things for the next (2.6.28) release
into -next.  That would give akpm time to get his load in as well.
Between -rc1 and -rc2, he could look at -next to see what patches were
picked up by maintainers and what he'll still have to send in himself.

But it's not me doing the work :-)

Keep up the good work Stephen/AKPM.

Harvey

