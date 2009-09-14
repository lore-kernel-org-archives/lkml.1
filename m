Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZINWfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZINWfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZINWfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:35:17 -0400
Received: from fifo99.com ([67.223.236.141]:52402 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbZINWfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:35:17 -0400
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
From: Daniel Walker <dwalker@fifo99.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
	 <1252961412.11643.215.camel@desktop>
	 <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com>
	 <1252962263.11643.232.camel@desktop>
	 <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com>
	 <1252963292.11643.259.camel@desktop>
	 <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:36:07 -0700
Message-Id: <1252967767.11643.286.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 18:17 -0400, Mike Frysinger wrote:
> 
> this code i had rewritten and as fallout, the style changed.  looks
> fine to me, and no, this particular checpatch "error" is not always
> worthwhile (like in this case).

Have you read Documentation/CodingStyle ? Can you better explain why
your don't want to follow that document ? Most people accept that to be
the style of code in Linux, and that is what checkpatch checks for..

We also have this quote from Documentation/SubmittingPatches

"4) Style check your changes.

Check your patch for basic style violations, details of which can be
found in Documentation/CodingStyle.  Failure to do so simply wastes
the reviewers time and will get your patch rejected, probably
without even being read.

At a minimum you should check your patches with the patch style
checker prior to submission (scripts/checkpatch.pl).  You should
be able to justify all violations that remain in your patch."

If you ultimately don't correct these changes, I'd ask that in the
future you submit pull requests for the blackfin architecture instead of
sending individual patches ..

Daniel

