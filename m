Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbXGISPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbXGISPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXGISPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:15:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbXGISPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:15:37 -0400
Date: Mon, 9 Jul 2007 11:14:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Two trivial whitespace fixes in lockdep/spinlock code
Message-Id: <20070709111451.d6c09e72.akpm@linux-foundation.org>
In-Reply-To: <1184003146.2453.29.camel@dhcp193.mvista.com>
References: <Pine.LNX.4.64.0707040213340.11634@jikos.suse.cz>
	<20070703171606.fb027c2b.akpm@linux-foundation.org>
	<1184003146.2453.29.camel@dhcp193.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 10:45:46 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> > Too trivial, sorry: we could generate 8 million patches like this.
> 
> Would you rather have one big patch that fixes a lot of this type of
> stuff, or not have these types of patches at all ?

I guess one-patch-per-subsystem-maintainer would be best.

Sent To: that maintainer, Cc:'d to me, ideally.  Some will resist.
