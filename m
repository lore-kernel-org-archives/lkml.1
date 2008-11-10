Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYKJF27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYKJF27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYKJF2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:28:50 -0500
Received: from 1wt.eu ([62.212.114.60]:1138 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYKJF2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:28:50 -0500
Date: Mon, 10 Nov 2008 06:28:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.37-rc2
Message-ID: <20081110052847.GB25874@1wt.eu>
References: <20081109234747.GA15813@hera.kernel.org> <4917C350.5080808@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917C350.5080808@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, Nov 09, 2008 at 09:14:56PM -0800, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> > 
> > The patch and changelog will appear soon at the following locations:
> >   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
> >   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37-rc2.bz2
> >   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37.log
> > 
> 
> You probably want to drop the .all. infix here; it gives you round-robin
> across all the kernel.org servers, instead of using geodns to get to the
> closest one.

Guess what ? I was precisely reading kernel.org home page announcing GeoDNS :-)
I've updated my release scripts accordingly.

Thanks!
Willy

