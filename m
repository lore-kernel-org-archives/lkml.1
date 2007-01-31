Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbXAaJHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbXAaJHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbXAaJHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:07:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:45611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbXAaJHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:07:36 -0500
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Rewriting floppy.c was Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
	<20070131012428.GA31759@kroah.com>
From: Andi Kleen <ak@suse.de>
Date: 31 Jan 2007 11:08:14 +0100
In-Reply-To: <20070131012428.GA31759@kroah.com>
Message-ID: <p7364anpkz5.fsf_-_@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> 
> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> that floppy.c is?  Do you want everyone just to run screaming from
> kernel development never to be seen again?

Doing a from-scratch rewrite of floppy.c only supporting new
hardware and no obscure formats ("newfloppy.c") would be an excellent 
newbie project imho.  This means for someone who is still pretty
new, but wants to get their fingers wet with more complicated changes.

Then over time (old-)floppy.c could be phased out.

If anybody is interested...? (non newbies would be welcome too of course)

-Andi
