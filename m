Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbYDZOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbYDZOwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYDZOwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:52:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757869AbYDZOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:52:22 -0400
Date: Sat, 26 Apr 2008 07:51:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-Id: <20080426075132.b0fdbe13.akpm@linux-foundation.org>
In-Reply-To: <20080426110044.GB2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick>
	<20080426110044.GB2252@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 14:00:44 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> Why do other people get over 100 checkpatch fixes into the tree at once 
> or Linus applies patches directly bypassing the maintainers (like the 
> one you sent just before [3], which I've also already sent before [4]) 
> but my patches bitrot forever?

If I am not cc'ed on a patch and have to resort to plucking it off the
mailing list it ends up being significantly more work and more error-prone
for me to process it.

I used to merge your patches but then you chose to stop ccing me on them so
I stopped applying them.  The increased hassle just isn't worth it for some
random make-foo-static patch.  I do try to keep an eye out for more
significant changes but hey, stuff happens.

You chose to disrupt the workflow and now you're here complaining and blaming
others for the consequences of your own action.
