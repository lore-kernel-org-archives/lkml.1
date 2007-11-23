Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKWAtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKWAtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXKWAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:49:27 -0500
Received: from www.tglx.de ([62.245.132.106]:49738 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbXKWAt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:49:26 -0500
Date: Fri, 23 Nov 2007 01:48:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <k.shutemov@velesys.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andreas Herrmann <aherrman@arcor.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
In-Reply-To: <20071122161826.61515a6d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711230146190.25057@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <20071122102205.GD7085@localhost.localdomain> <20071122161826.61515a6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007, Andrew Morton wrote:

> On Thu, 22 Nov 2007 12:22:05 +0200 "Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:
> 
> > On x86_64 'uname -m' return 'x86'.  It break many userspace programs. apt
> > and rpm for example.
> > 
> 
> Yes, there have been various discussions about this.  I think Sam is cooking up
> a fix?

http://lkml.org/lkml/2007/11/19/323

I push it Linus wards ASAP.

Thanks,

	tglx
