Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYKMJiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYKMJiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYKMJhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:37:52 -0500
Received: from styx.suse.cz ([82.119.242.94]:32947 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750728AbYKMJhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:37:51 -0500
Date: Thu, 13 Nov 2008 10:37:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Klimov <klimov.linux@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, Tobias Lorenz <tobias.lorenz@gmx.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: next: 6a13378a5 (Don't allow KWorld radio...) is broken
In-Reply-To: <208cbae30811121824g2e2d4f3bvf2c982c9f54b30a2@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0811131037020.32143@jikos.suse.cz>
References: <491B3E90.5020307@gmail.com> <208cbae30811121824g2e2d4f3bvf2c982c9f54b30a2@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Alexey Klimov wrote:

> > Alexey, did you actually test it?
> > I'd prefer taking this through my tree, if it doesn't impose any problem
> > on your side. Could you please fix it up and resend?
> It good thing to do. May i make patch against current kernel tree 
> (rc4-git3) ? I also going to make patch for radio-mr800 that has wrong 
> hidquirks too. I can send now, because this two patches ready.

Thanks, I have applied both patches to my tree (but please remember to 
always send kernel patches so that they apply using "patch -p1", I had to 
fix this by hand).

Thanks,

-- 
Jiri Kosina
SUSE Labs
