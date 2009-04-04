Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZDDQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZDDQJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZDDQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:08:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:48088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbZDDQI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:08:57 -0400
Date: Sat, 4 Apr 2009 09:08:51 -0700
From: Greg KH <gregkh@suse.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Commit 7a192ec is build breaking
Message-ID: <20090404160851.GA9828@suse.de>
References: <20090328140049.GA4344@flint.arm.linux.org.uk> <20090404041740.GA6504@suse.de> <d82e647a0904040018n6e5a261eodcb42d4bb76e65aa@mail.gmail.com> <20090404094453.GA11209@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090404094453.GA11209@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 10:44:53AM +0100, Russell King wrote:
> Note that since I was sending a new set of ARM fixes a couple of days
> ago and there didn't seem to be anyone listening to my emails, I fixed
> the PXA flash driver myself.  Linus now has that fix.

Sorry, I was out of the country for a week.

So, we don't need to revert the original change now?

Again, sorry for the delay.

greg k-h
