Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZJZUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZJZUzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZJZUzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:55:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbZJZUzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:55:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
Date: Mon, 26 Oct 2009 21:57:37 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Massimo Cetra <mcetra@navynet.it>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.B9G.nre5KB@chimera> <4AE5FD84.8070906@gmail.com>
In-Reply-To: <4AE5FD84.8070906@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910262157.37392.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Eric Dumazet wrote:
> Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
> > Subject		: Problems with net/core/skbuff.c
> > Submitter	: Massimo Cetra <mcetra@navynet.it>
> > Date		: 2009-10-08 14:51 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4
> > 
> > 
> 
> This was corrected by commit ed79bab847d8e5a2986d8ff43c49c6fb8ee3265f
> 
> virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()

Thanks, closing.

Rafael
