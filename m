Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0BERWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:22:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab0BERWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:22:50 -0500
Date: Fri, 5 Feb 2010 09:12:50 -0800
From: Greg KH <gregkh@suse.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [00/74] 2.6.32.8-stable review
Message-ID: <20100205171250.GC14145@suse.de>
References: <20100204171850.GA16539@kroah.com> <20100205073659.GD31093@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205073659.GD31093@develbox.linuxbox.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 08:36:59AM +0100, Nikola Ciprich wrote:
> Hi Greg,
> just tried it, and it crashes during boot.
> Previous 2.6.32.x versions were OK.
> here is the screen:
> http://nelide.cz/downloads/2.6.32.8-crash.png
> sorry if it's a bit crude, but I'm leaving for 4 days vacation,
> so I'm in a bit of hurry :)
> On Tuesday, I can provide more testing/whatever if needed.

Can you try the -rc2 release I just made if you get a chance?  It should
resolve this issue.

thanks,

greg k-h
