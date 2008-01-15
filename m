Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbYAOOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbYAOOiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYAOOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:37:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60634 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYAOOh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:37:57 -0500
Date: Tue, 15 Jan 2008 15:37:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Yuusei KUWANA <kuwana@nyanyan.to>
Subject: Re: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and use common defines
Message-ID: <20080115143757.GA17947@uranus.ravnborg.org>
References: <20080115133624.GD3912@axis.com> <20080115135419.GA17685@uranus.ravnborg.org> <20080115142300.GE3912@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115142300.GE3912@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What about applying the same fixes/changes to v32?
> 
> In the works.
> 
> > It would btw. be nice to move the vmlinux.lds.S files to
> > arch/cris/kernel/.
> > Se how x86 handle build for two different bit sizes.
> > 
> > If this is done then cris is less awkward compared
> > to the other archs.
> 
> That's a really good idea. I'll add that to my todo-list.

Thanks Jesper.
It is good to see cris getting some love and care in the public!

	Sam
