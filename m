Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbXJJXhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbXJJXhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbXJJXh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:37:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbXJJXh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:37:28 -0400
Date: Wed, 10 Oct 2007 16:36:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Message-Id: <20071010163625.b4b438ec.akpm@linux-foundation.org>
In-Reply-To: <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
References: <1192053794.15601.47.camel@gaivota>
	<d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 01:00:39 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

Please don't send 900 line emails to which you have added only an additional
paragraph.

> >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> 
> not accepted

Until your attempt to get the userspace-driver work merged into the kernel
is successful (and from my reading of last month's discussion it is nowhere
near that), we should continue to maintain the present driver.

If you choose to not participate in that maintenance then others will need
to do their best in this regard.

What we should not and will not do is to permit the current driver to be
held hostage to your attempt to force a controversial and apparently
unwelcome change into the tree.


