Return-Path: <linux-kernel-owner+w=401wt.eu-S1764768AbYBNSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764768AbYBNSjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYBNSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:39:31 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:34890 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYBNSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:39:30 -0500
Message-ID: <47B48AD1.9010105@panasas.com>
Date: Thu, 14 Feb 2008 20:39:13 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
References: <20080215003537.8911ce35.sfr@canb.auug.org.au> <86802c440802141029w5b409b9bl6a2dbc377ea913f2@mail.gmail.com>
In-Reply-To: <86802c440802141029w5b409b9bl6a2dbc377ea913f2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 14, 2008, 20:29 +0200, "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> On Thu, Feb 14, 2008 at 5:35 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>>  I have created the first cut of the linux-next tree at
>>  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
>>
>>  Things to know about this tree:
>>
>>  It has two branches - master and stable.  Stable is currently just Linus'
>>  tree and will never rebase.  Master will rebase on an almost daily basis
>>  (maybe slower at the start).
> 
> can you make stable rebase too?

The point is that if you rebase it it's no longer stable.

Benny

> 
> so we make git-bisect working by fold in some obvious bug fix.
> 
> or that is linux-stable tree?
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

