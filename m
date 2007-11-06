Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXKFMgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXKFMgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXKFMgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:36:31 -0500
Received: from mx10.go2.pl ([193.17.41.74]:53184 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755014AbXKFMga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:36:30 -0500
Date: Tue, 6 Nov 2007 13:40:18 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Theodore Tso <tytso@mit.edu>
Cc: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Policy on dual licensing?
Message-ID: <20071106124018.GA1666@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104000443.GB30710@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-11-2007 01:04, Theodore Tso wrote:
> On Sat, Nov 03, 2007 at 12:14:15PM +0000, Remigiusz Modrzejewski wrote:
>> We've all seen the last flame war about Linux stealing BSD code. Due to
>> Theo's bad wording whole discussion rolled around the question about
>> legality of this, a big waste of time (question answered a thousand
>> times). Still, the question about ethics is quite valid...
> 
> Please let's not restart the flame war then.

Why not? Is it better to stay enemies forever? Sometimes, after the
war miracles happen and bitter enemies become friends...

...
> [...]  There are those who believe that there is nothing wrong,
> either morally, ethically, or legally, with taking BSD code, and not
> dual-licesing it when adding GPL-specific additions. [...]

IMHO, the main problem is talking about these things instead of
some basics:

1. BSD copyright is simple here:

   "1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer."

   So, when I read on lkml, there are people, thinking they actually
   can add here and there something about GPL, or even remove it at
   all, we have a problem... Any legal, moral or ethical reasoning
   here is useless (but gathering some weapons should be safe bet).

2. After retaining such a copyright, IMHO the war is over and BSD guys
   call as the best friends! If we are very clever and stay with this
   only, they probably can even become our slaves (if they are so
   "incredibly silly" as presumed).

3. Otherwise, we have a problem: anything added or changed looks like
   BSD copyrighted too. And this is really a legal, moral and ethical
   problem, but it's our internal problem (I doubt BSD people are
   silly enough to fight for these additions). If you haven't guessed,
   I'm in the earlier camp...

Regards,
Jarek P.
