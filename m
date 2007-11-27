Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXK0XWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXK0XWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760704AbXK0XVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:21:51 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35026 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760631AbXK0XVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:21:50 -0500
Date: Wed, 28 Nov 2007 00:21:39 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071127232139.GJ3406@stusta.de>
References: <20071125172237.GC6658@kernel.dk> <20071127070912.GB1735@ff.dom.local> <20071127164723.GA3406@stusta.de> <474C9714.1080308@o2.pl> <474CA1F0.3090504@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474CA1F0.3090504@o2.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:02:08AM +0100, Jarek Poplawski wrote:
> Jarek Poplawski wrote, On 11/27/2007 11:15 PM:
> ...
> 
> > Otherwise it's not so hard to overlook some stagnation.
> 
> Btw., after this 'forking' thing etc. it seems I might have lost the point
> a little: which removed choices should justify such a fork.

Let me try to rephrase it:

If you think an open source project does something wrong you have the 
right to fork it and offer an (in your opinion) better version.

This is the right you have.

But if you think open source gives you any legal or moral right to 
demand any featurs or choices or whatever from developers you are 
completely mistaken.

> But, I hope,
> you didn't mean your patch only, because then e.g. this stagnation threat
> looks like a bit exaggerated...

The question how many I/O schedulers we need is anyway in no direction 
related to my patch.

> Jarek P.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

