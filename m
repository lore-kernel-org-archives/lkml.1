Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXKFIHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXKFIHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbXKFIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:07:05 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41752 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753648AbXKFIHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:07:02 -0500
Date: Tue, 6 Nov 2007 09:06:38 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106080637.GB26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 08:21:04AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 5 Nov 2007, Ahmed S. Darwish wrote:
> 
> > On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
> > > 
> > > Can we avoid string parsers in the kernel?
> > > 
> > 
> > Ok, Could someone suggest a better idea please ?. 
> 
> I personally think string parsers are *much* better than the alternatives 
> (which basically boil down to nasty binary interfaces)
>...

How do we get the information about the character encoding of the string 
to be parsed into the kernel?

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

