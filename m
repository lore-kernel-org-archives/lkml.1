Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbXJNUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbXJNUuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXJNUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:50:15 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:45418 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170AbXJNUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:50:13 -0400
Date: Sun, 14 Oct 2007 22:49:49 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org,
       torvalds@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <20071014204949.GA11807@linuxtv.org>
References: <1192053794.15601.47.camel@gaivota> <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com> <20071010163625.b4b438ec.akpm@linux-foundation.org> <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0710140340l850acd3r64c7d0ba51eee1e1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 87.162.96.182
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007, Markus Rechberger wrote:
> 
> the reason why I take the em28xx as hostage is, well I started with it
> and I work with that company and I don't see a way how to implement
> the latest devices without terrible hacks (and there are around 60
> devices supported only by the current available driver and it will
> double that number since customers will change several chips on those
> boards)
...
> I pulled all my linux opensource projects offline till this is cleared
> up I don't want to do 90% of all work and people taking over my
> project doing 10% of hacks for getting some credits. The long time
> support is not related to linux only.

It is a bit naive for you to believe you can remove your GPL
distributed work from the internet by deleting it from your server.

If your kernel driver work would be merged into the kernel it
would retain your copyrights and Signed-off-by: attributions,
so it would be visible for everyone that it is your work. If
you can't live with that, then why on earth did you join a
project developing software released under the GPL? Why did
you release your own software under the GPL?

Since you seem obsessed with keeping control over your
work it is funny that you mention BSD, as the BSD license
is even less restrictive than the GPL.


Johannes
