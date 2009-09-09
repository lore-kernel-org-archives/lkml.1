Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZIIOh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZIIOh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZIIOh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:37:59 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:58315 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZIIOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=V5LBToJOYi1SeGgqrgzV9VGobXeXgzkb6uaNZuNsvtvG4Ai1Qsy0INTJkaftX4d/Lk
         YmSHNo3kej3b38dwGAHD+xIlPUFGCqSzy4z6dXb1JeJMTWjWWdVZYl/GdWpK516SVpc3
         Ab2qRTOzaA0+LFsBuFRFcVmK7nSMsVNaz7F0o=
MIME-Version: 1.0
In-Reply-To: <20090909075024.GA1400@ucw.cz>
References: <20090909075024.GA1400@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 9 Sep 2009 22:37:41 +0800
Message-ID: <f17812d70909090737n4315d0cbh82c0a63e9222fdb5@mail.gmail.com>
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
To: Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 3:50 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi, Linus!
>
> Spitz resume was broken for year or likely two, and it would be very
> nice to fix it for 2.6.31 release. One liner is below, and it really
> can not harm. It already is in Eric's fix queue, so pulling that for
> .31 should work, too.
>

This should be sitting in rmk's git tree and I'm not sure if Russell
has sent the pull request already.
