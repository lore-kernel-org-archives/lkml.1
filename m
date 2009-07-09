Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZGIXq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZGIXq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZGIXqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:46:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50725 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726AbZGIXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:46:49 -0400
Date: Fri, 10 Jul 2009 00:47:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: ttydev tree import failure
Message-ID: <20090710004743.202b36e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090710091408.67c4da53.sfr@canb.auug.org.au>
References: <20090710091408.67c4da53.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 09:14:08 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> Today's linux-next import of the ttydev tree failed like this:
> 
> tty-usb-mos7720-modem
> error: usb/serial/mos7720.c: does not exist in index
> 
> It looks like a -p0 patch was included in the comments?  I removed the
> -p0 patch (hopefully that was the correct one).

Interesting - stgit seems totally happy with it all (and applied it to
the right place). I'll have a poke and sort it out.

