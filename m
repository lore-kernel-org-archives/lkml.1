Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbZDQVoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbZDQVoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZDQVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:44:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZDQVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:44:44 -0400
Date: Fri, 17 Apr 2009 14:41:10 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.31-rc2
Message-ID: <20090417214110.GA29546@suse.de>
References: <20090417190139.GA3548@kroah.com> <a4423d670904171412y323c38ech819652633e8674c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904171412y323c38ech819652633e8674c5@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 01:12:45AM +0400, Alexander Beregalov wrote:
> Hi Greg
> This patch should be here as well
> http://marc.info/?l=linux-next&m=123996717119063&w=2
> it fixes a build problem introduced by "USB: musb: fix possible panic
> while resuming"

You sent that patch to me earlier today.  I need David to ack it, and
for it to live in linux-next a bit before being able to send it to
Linus.

thanks,

greg k-h
