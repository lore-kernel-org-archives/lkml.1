Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZLNDL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZLNDL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbZLNDL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:11:28 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3912 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbZLNDL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:11:28 -0500
Date: Sun, 13 Dec 2009 20:11:27 -0700
From: Alex Chiang <achiang@hp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: rjw@sisk.pl, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: radeon 4830 corruption after resume
Message-ID: <20091214031127.GB29591@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com> <1260759123.3391.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260759123.3391.0.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Airlie <airlied@redhat.com>:
> On Sun, 2009-12-13 at 19:30 -0700, Alex Chiang wrote:
> > Hi Dave, Rafael,
> > 
> > I can successfully suspend/resume my HP Envy, but upon resume,
> > the screen is corrupted.
> > 
> > I used the gnome screenshot utility to capture this:
> > 
> > 	http://chizang.net/alex/tmp/radeon-4830-corruption.png
> > 
> > But that screenshot leads you to believe the corruption was
> > 100%, when in reality, the text in my xterms was at least
> > readable, but ugly.
> > 
> > Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.
> 
> Has it ever worked? can you suspend/resume without X running at all?

Hm, define "worked"?

The machine responds to keyboard, mouse, network input, etc. It's
just that the screen is garbled.

Unless I'm not understanding what you're asking?

> Its quite possibly a userspace problem but its hard to know, we
> haven't changed the user modesetting pieces in the kernel at all in
> quite a while.

Ok, I'm just looking for where/how to start debugging. Any advice
on where to look next would be fine too.

Thanks,
/ac

