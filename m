Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZFSGbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZFSGbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZFSGax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:30:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:52555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZFSGaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:30:52 -0400
Subject: Re: [PATCH 0/5, resend] x86: use asm-generic headers where possible
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 12:00:58 +0530
Message-Id: <1245393058.2463.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On Thu, 2009-06-18 at 21:48 +0200, Arnd Bergmann wrote:
> I did not get any feedback on this the last time I sent it,
> but now these patches actually apply to the mainline kernel
> so it's possible to apply them.
> 
> I've split the series up into five patches for easier review.
> Each step should show clearly that no semantic changes are
> introduced, with the exception of termios.h, which was
> discussed earlier.
> 

Nice work.

IMHO, if you provide above steps for each file for all architecture then
it shows clearly how generic that file is and no one should have any
objection as long as nothing breaks and because of generic percentage
(percentage above 70 % will be better one). And collect acks from
maintainers and send pull request to Linus.

If you also provide complete diff, then it looks much better.

And if you need my help just ping me :-)

Thanks,
--
JSR

