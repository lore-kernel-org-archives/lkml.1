Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXEADcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXEADcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbXEADcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:32:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:47458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbXEADcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:32:09 -0400
Date: Tue, 1 May 2007 06:29:39 +0200
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <20070501042939.GM25929@bingen.suse.de>
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com> <4636A332.2070101@zytor.com> <m1odl51dci.fsf@ebiederm.dsl.xmission.com> <20070501034612.GK25929@bingen.suse.de> <4636ABE3.5070502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4636ABE3.5070502@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 07:54:27PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> Not that the x86 BIOS is bad.  It is nearly a marvel in it's simplicity
> >> and ubiquitousness, 
> > 
> > Simplicity? That must be why x86 motherbords are shipping with (compressed) 
> > 8MB BIOS flash chips now.
> 
> Very little of that is the actual BIOS, though.  Most of it is generally
> QuickPlay, which tends to be a Linux system...

At least my Asus board with 8Mb flash doesn't have anything called that.
There is also no special preboot environment

iirc Asus ships dual BIOS though, but even half that compressed is a lot.

-Andi

