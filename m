Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYBLWSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYBLWSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYBLWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:18:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYBLWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:18:30 -0500
Date: Tue, 12 Feb 2008 14:17:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
       James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       davem@davemloft.net, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212141726.1e214729.akpm@linux-foundation.org>
In-Reply-To: <20080212215152.1470fe7f@core>
References: <20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212194100.GH27894@ZenIV.linux.org.uk>
	<20080212215152.1470fe7f@core>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 21:51:52 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > We could simply decide that API changes affecting more than one subsystem
> > Must Be Serialized(tm).  Explicitly.  As in "any such change is posted
> 
> Welcome to dreamland. The only way I can get serial changes done is to
> wait months and eventually simply persuade Andrew to ignore the
> "maintainers" who are basically not responding.

"maintainers"?

I think the best way to get the serial drivers maintained would be to cat
them all onto the end of synclink.c and hope that Paul thinks he did it.

