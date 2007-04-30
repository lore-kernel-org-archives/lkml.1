Return-Path: <linux-kernel-owner+w=401wt.eu-S1423169AbXD3JAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423169AbXD3JAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423173AbXD3JAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:00:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:48652 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1423169AbXD3I7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:59:51 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1+uurMVaEeuKo/7qqM106q/h3NxHfUmNLmuL9ExiQ
	4D0kAmAST0lhcx
Date: Mon, 30 Apr 2007 10:59:48 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Andrew Wang <andrewxwang@yahoo.com.tw>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
Message-ID: <20070430085948.GC3701@merlin.emma.line.org>
Mail-Followup-To: Andrew Wang <andrewxwang@yahoo.com.tw>,
	linux-kernel@vger.kernel.org
References: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-24)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Andrew Wang wrote:

> ZFS has some nice features, but ReiserFS4 also is a
> good file system.
> 
> Why do we want Sun to release ZFS under GPL, while
> ReiserFS4 is already available under GPL!?

Reiser4 doesn't appear to work anywhere except with Linux AFAICT, and
being able to move storage between operating systems sure looks
interesting...

> I think for those who ask/beg Sun to release ZFS under
> GPL should do the work to get ReiserFS4 to Linux!

Perhaps you might ask them first if they have looked into porting
Reiser4 to kernel style, ripping out duplicate code - or they decided
that would be a more boring job than porting ZFS :-)

-- 
Matthias Andree
