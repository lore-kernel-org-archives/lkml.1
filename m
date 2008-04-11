Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYDKBIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYDKBIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbYDKBIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:08:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32894
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbYDKBH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:07:59 -0400
Date: Thu, 10 Apr 2008 18:08:00 -0700 (PDT)
Message-Id: <20080410.180800.62052963.davem@davemloft.net>
To: tilman@imap.cc
Cc: lkml@rtr.ca, jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FEB751.7040703@imap.cc>
References: <47FEADCB.7070104@rtr.ca>
	<20080410.172453.44434205.davem@davemloft.net>
	<47FEB751.7040703@imap.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Fri, 11 Apr 2008 02:56:49 +0200

> I think you got it backwards. Mark and other bug reporters (including,
> at times, yours truly) are helping you and other developers to make
> Linux better.

I appreciate the bug reports, believe me.

The issue is which of the limited developer resources get put onto
which bugs.

A developer who does this for fun is going to prioritize to things
that are pleasant and interesting to work on, and also a good
effective use of their time.

So people prioritize.

Therefore, my point is, the net result is that user have a direct
influence on which bugs get worked on with the highest priority and
thus get fixed faster.  And those are the ones that have the most
information available, and in particular bisec results when
appropriate.
