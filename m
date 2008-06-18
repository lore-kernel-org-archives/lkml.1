Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYFRJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYFRJ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYFRJ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:58:31 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45833 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYFRJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:58:30 -0400
Date: Wed, 18 Jun 2008 11:58:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.26-rc6
In-Reply-To: <20080617180508.GA9057@anvil.corenet.prv>
Message-ID: <Pine.LNX.4.64.0806181156250.21793@twin.jikos.cz>
References: <20080617180508.GA9057@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Dmitry Torokhov wrote:

> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for the input subsystem. There will be a small
> conflict in drivers/usb/core/quirks.c, I hope this is OK because I don't
> like to have merges on my 'for-linus' branch except for the one done in
> merge window for the next release. This way one can clearly see what
> went in into a release after the initial merge.
> 
> Changelog:
> ---------
> 
> Jiri Kosina (2):
>       Input: i8042 - add Fujitsu-Siemens Amilo Pro V2030 to nomux table
>       Input: i8042 - retry failed CTR writes when resuming

Hi Dmitry,

how about my patch

	Input: i8042 - add Intel D845PESV to nopnp list

Not that it couldn't wait for next merge window, I just want to make sure 
that it doesn't get lost.

Thanks,

-- 
Jiri Kosina
SUSE Labs

