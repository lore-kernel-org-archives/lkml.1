Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbXIKLyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbXIKLyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXIKLy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:54:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51299 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXIKLy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:54:27 -0400
Date: Tue, 11 Sep 2007 13:55:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Message-ID: <20070911115551.GA5544@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709102002.15383.vda.linux@googlemail.com> <20070910191402.GB31541@uranus.ravnborg.org> <200709111223.04724.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709111223.04724.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But then we need to annotate ALL arch linker script before introducing this.
> > And that bring me back to that we should put some sanity into these first.
> 
> I was working with x86_64 ld script and am willing to clean it up a bit.
> 
> I can impelment and test DISCARD_UNUSED_SECTIONS for x86_64 and later
> for i386.
> 
> Other arches can follow when they find it interesting/worthwhile.
> 
> At first, big scary warning under "config DISCARD_UNUSED_SECTIONS"
> should be enough to make people avoid it for production boxes, I hope.
> 
> Should I send next round of patches to you or to Andrew?

Please send them to me with appropriate cc's.

	Sam
