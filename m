Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbXCSLFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbXCSLFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXCSLFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:05:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbXCSLFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:05:40 -0400
Date: Mon, 19 Mar 2007 07:05:29 -0400
From: Alan Cox <alan@redhat.com>
To: Paul Rolland <rol@as2917.net>
Cc: "'Tejun Heo'" <htejun@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
Message-ID: <20070319110529.GC24026@devserv.devel.redhat.com>
References: <45FE137D.8000300@gmail.com> <005501c769fa$ee402470$4b00a8c0@donald>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005501c769fa$ee402470$4b00a8c0@donald>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:48:00AM +0100, Paul Rolland wrote:
> Would you agree to a patch to add a kernel boot parameter to skip some
> ata ports ?

It should in theory not be neccessary

> I found some archives refering to some "ataX=noprobe", but it seems
> to have no effect, and I'd like to resurrect it for libata, at least to
> help me support my configuration ?
> If no, I'll just cook it for me, without posting it...

If you get it working please post patches - theory and practice rarely agree 8)
