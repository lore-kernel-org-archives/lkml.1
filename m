Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770Ab0AEPKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0AEPKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022Ab0AEPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:10:11 -0500
Received: from tex.lwn.net ([70.33.254.29]:52669 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0AEPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:10:09 -0500
Date: Tue, 5 Jan 2010 08:10:00 -0700
From: Jake Edge <jake@lwn.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [PATCH 97/97] Linux 2.6.32.3-rc1
Message-ID: <20100105081000.0c570fd2@chukar>
In-Reply-To: <20100105145854.GA11988@suse.de>
References: <20100105003133.GA7199@kroah.com>
	<1262651630-7354-97-git-send-email-gregkh@suse.de>
	<20100104181307.2eb47785@chukar>
	<20100105145854.GA11988@suse.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 06:58:54 -0800 Greg KH wrote:
> On Mon, Jan 04, 2010 at 06:13:07PM -0700, Jake Edge wrote:
> > On Mon,  4 Jan 2010 16:33:50 -0800 Greg Kroah-Hartman wrote:
> > 
> > > +EXTRAVERSION = .3-rc1
> > 
> > This looks like a typo.  Why the '-rc1'?
> 
> I'm curious as to why you feel this is a typo when I was announcing
> the release of the 2.6.32.3-rc1 kernel?

my apologies, i thought you were announcing the review of the 2.6.32.3
kernel.  it would seem i misunderstood, but i hadn't noticed patches
like this in previous stable reviews, and i thought that version string
would end up in the 2.6.32.3 release, which, i think anyway, would be
wrong.

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
