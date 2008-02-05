Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYBEOKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYBEOKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYBEOKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:10:08 -0500
Received: from hempcity.net ([81.171.100.190]:36302 "EHLO hempcity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYBEOKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:10:06 -0500
Message-ID: <59776.81.171.100.191.1202220590.squirrel@webmail.coolzero.info>
In-Reply-To: <20080205140216.GD12009@ruf099.fkie.fgan.de>
References: <20080205100423.GA12009@ruf099.fkie.fgan.de>
    <38602.81.171.100.191.1202213194.squirrel@webmail.coolzero.info>
    <20080205140216.GD12009@ruf099.fkie.fgan.de>
Date: Tue, 5 Feb 2008 15:09:50 +0100 (CET)
Subject: Re: OOM killer on idle machine
From: "Jim van Wel" <jim@coolzero.info>
To: "Michael Bussmann" <bus@mb-net.net>
Cc: linux-kernel@vger.kernel.org
Reply-To: jim@coolzero.info
User-Agent: SquirrelMail/1.4.8-4.0.1.el4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Funny,

I also got 32bits kernels running, and moving to 64bits because that's
more stable what we tested here...

Greetings,
Jim.

> Hi Jim,
>
> On 2008-02-05 13:06:34 +0100, Jim van Wel wrote:
>
>> http://lkml.org/lkml/2007/11/6/44
>
> Oops, I didn't expect the problem to be 3 months old.  Next time I'll
> browse the archives more thoroughly.
>
>> Got same issue, but somewhat different hardware. I'm really wondering,
>> are
>> you using a 64bits kernel or a 32bit?
>
> It's a 32-bit kernel.  Hmm, there are two similar systems at a customer's
> site with a 64-bit kernel that don't seem to be affected by this bug.
> Another system with a 32-bit kernel is still running, but it only has 2 GB
> RAM in it.  Interesting...
>
> Cheers,
> MB
>
> --
> Michael Bussmann <bus@mb-net.net>
> BOFH excuse #232:
>
> Ionization from the air-conditioning
>

