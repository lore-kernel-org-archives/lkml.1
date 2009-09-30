Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZI3KQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZI3KQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZI3KQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:16:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38288 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751863AbZI3KQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:16:51 -0400
Date: Wed, 30 Sep 2009 11:17:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree boot crash] Re: [GIT PATCH] TTY patches for
 2.6.31-git
Message-ID: <20090930111726.618af641@lxorguk.ukuu.org.uk>
In-Reply-To: <20090930100902.GA29872@elte.hu>
References: <20090919213345.GB7668@kroah.com>
	<20090930100902.GA29872@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 12:09:02 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> >       serial: use tty_port pointers in the core code
> 
> -tip testing found a weird serial code related crash on a testbox: the 
> box does spontaneous reboot during the user-space portions of bootup. 

Does this only occur if running with serial console ?

