Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYHNWAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYHNWAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYHNWAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:00:42 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:32624 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbYHNWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:00:42 -0400
Date: Fri, 15 Aug 2008 00:01:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Alpha - move header files [Was Re: [PATCH] h8300 move header files]
Message-ID: <20080814220108.GA10536@uranus.ravnborg.org>
References: <871w0wvgng.wl%ysato@users.sourceforge.jp> <20080811170534.22f26b7e.akpm@linux-foundation.org> <20080812051101.GA21095@uranus.ravnborg.org> <87myjiq960.wl%ysato@users.sourceforge.jp> <alpine.LFD.1.10.0808121322190.3462@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121322190.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 01:25:17PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Aug 2008, Yoshinori Sato wrote:
> > 
> > My h8300 repository can't public access.
> > Also difficult pull request.
> 
> The nice thing about git is that it doesn't care one whit how something 
> gets moved. So you can
> 
>  - just send me a regular patch (as a git user, it can be the "git 
>    shorthand" kind of patch that has explicit renames, but it can be a 
>    traditional patch with delete/create pairs too, and git won't care AT 
>    ALL because the end result is the same)
> 
>  - or just send me a shell script to do the renames along with a small 
>    patch to fix up any other issues that happen as a result of the rename, 
>    and a explanation for me to use as a commit message.
> 
> Renames in git do not have to be handled as "git" events, unlike many 
> other broken models. Git will do the right thing regardless.
> 

I have build-tested alpha with a simple header file move.
Can I ask you to do a simple move of all header files for alpha
like you did for h8300.

[I could set up a git tree etc. but being busy with my new house arm]

Thanks,
	Sam

